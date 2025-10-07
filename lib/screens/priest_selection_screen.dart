import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/priests_provider.dart';
import '../models/priest.dart';
import '../widgets/selection_item_widget.dart';
import '../utils/app_colors.dart';

class PriestSelectionScreen extends StatefulWidget {
  const PriestSelectionScreen({super.key});

  @override
  State<PriestSelectionScreen> createState() => _PriestSelectionScreenState();
}

class _PriestSelectionScreenState extends State<PriestSelectionScreen> {
  List<String> _selectedPriestIds = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPriests();
  }

  void _loadPriests() {
    final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
    priestsProvider.fetchPriests();
  }

  List<Priest> get _filteredPriests {
    final priestsProvider = Provider.of<PriestsProvider>(context);
    final allPriests = priestsProvider.allPriests;
    
    if (_searchQuery.isEmpty) {
      return allPriests;
    }
    
    return allPriests.where((priest) {
      return priest.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (priest.church?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
             (priest.rank?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  void _togglePriestSelection(String priestId) {
    setState(() {
      if (_selectedPriestIds.contains(priestId)) {
        _selectedPriestIds.remove(priestId);
      } else {
        _selectedPriestIds.add(priestId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedPriestIds = _filteredPriests.map((priest) => priest.id).toList();
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedPriestIds.clear();
    });
  }

  void _confirmSelection() {
    if (_selectedPriestIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار كاهن واحد على الأقل'),
          backgroundColor: AppColors.statusInactive,
        ),
      );
      return;
    }

    // Apply filter to priests provider
    final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
    priestsProvider.filterPriestsByIds(_selectedPriestIds);
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'اختيار الآباء الكهنة الحاضرين',
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
          if (_selectedPriestIds.isNotEmpty)
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
                    hintText: 'البحث بالاسم أو الكنيسة أو الرتبة...',
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
                      borderSide: const BorderSide(color: AppColors.cardPriest),
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
                        'تم اختيار ${_selectedPriestIds.length} من ${_filteredPriests.length} كاهن',
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
                          color: AppColors.cardPriest,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Priests list
          Expanded(
            child: Consumer<PriestsProvider>(
              builder: (context, priestsProvider, child) {
                if (priestsProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.cardPriest,
                    ),
                  );
                }

                if (_filteredPriests.isEmpty) {
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
                              ? 'لا يوجد كهنة'
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
                  itemCount: _filteredPriests.length,
                  itemBuilder: (context, index) {
                    final priest = _filteredPriests[index];
                    final isSelected = _selectedPriestIds.contains(priest.id);
                    
                    return SelectionItemWidget(
                      item: priest,
                      isSelected: isSelected,
                      isBishop: false,
                      onTap: () => _togglePriestSelection(priest.id),
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
                  backgroundColor: AppColors.cardPriest,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'تأكيد الاختيار (${_selectedPriestIds.length})',
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
