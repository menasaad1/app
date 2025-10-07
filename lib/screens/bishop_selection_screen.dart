import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bishops_provider.dart';
import '../models/bishop.dart';
import '../widgets/selection_item_widget.dart';
import '../utils/app_colors.dart';

class BishopSelectionScreen extends StatefulWidget {
  const BishopSelectionScreen({super.key});

  @override
  State<BishopSelectionScreen> createState() => _BishopSelectionScreenState();
}

class _BishopSelectionScreenState extends State<BishopSelectionScreen> {
  List<String> _selectedBishopIds = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBishops();
  }

  void _loadBishops() {
    final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
    bishopsProvider.fetchBishops();
  }

  List<Bishop> get _filteredBishops {
    final bishopsProvider = Provider.of<BishopsProvider>(context);
    final allBishops = bishopsProvider.allBishops;
    
    if (_searchQuery.isEmpty) {
      return allBishops;
    }
    
    return allBishops.where((bishop) {
      return bishop.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (bishop.diocese?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  void _toggleBishopSelection(String bishopId) {
    setState(() {
      if (_selectedBishopIds.contains(bishopId)) {
        _selectedBishopIds.remove(bishopId);
      } else {
        _selectedBishopIds.add(bishopId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedBishopIds = _filteredBishops.map((bishop) => bishop.id).toList();
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedBishopIds.clear();
    });
  }

  void _confirmSelection() {
    if (_selectedBishopIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار أسقف واحد على الأقل'),
          backgroundColor: AppColors.statusInactive,
        ),
      );
      return;
    }

    // Apply filter to bishops provider
    final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
    bishopsProvider.filterBishopsByIds(_selectedBishopIds);
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'اختيار الأساقفة الحاضرين',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_selectedBishopIds.isNotEmpty)
            TextButton(
              onPressed: _deselectAll,
              child: const Text(
                'إلغاء الكل',
                style: TextStyle(
                  color: AppColors.statusInactive,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'البحث بالاسم أو الأبرشية...',
                    hintStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.textLight,
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primaryPurple),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Selection info and controls
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'تم اختيار ${_selectedBishopIds.length} من ${_filteredBishops.length} أسقف',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _selectAll,
                      child: const Text(
                        'تحديد الكل',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Bishops list
          Expanded(
            child: Consumer<BishopsProvider>(
              builder: (context, bishopsProvider, child) {
                if (bishopsProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
                  );
                }

                if (_filteredBishops.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty 
                              ? 'لا يوجد أساقفة'
                              : 'لا توجد نتائج للبحث',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _filteredBishops.length,
                  itemBuilder: (context, index) {
                    final bishop = _filteredBishops[index];
                    final isSelected = _selectedBishopIds.contains(bishop.id);
                    
                    return SelectionItemWidget(
                      item: bishop,
                      isSelected: isSelected,
                      isBishop: true,
                      onTap: () => _toggleBishopSelection(bishop.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: AppColors.borderLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _confirmSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'تأكيد الاختيار (${_selectedBishopIds.length})',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
