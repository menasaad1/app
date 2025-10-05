import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/bishops_provider.dart';
import '../providers/priests_provider.dart';
import '../providers/app_mode_provider.dart';
import '../models/bishop.dart';
import '../models/priest.dart';
import '../widgets/bishop_card.dart';
import '../widgets/priest_card.dart';
import '../widgets/sort_dialog.dart';
import '../widgets/mode_selector_widget.dart';
import '../widgets/safe_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataAsync();
    });
  }

  Future<void> _loadDataAsync() async {
    final appModeProvider = Provider.of<AppModeProvider>(context, listen: false);
    final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
    final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
    
    try {
      // Load mode first
      await appModeProvider.loadMode();
      
      // Load data based on mode
      if (appModeProvider.isBishopsMode) {
        bishopsProvider.fetchBishops(); // Don't await to make it faster
      } else {
        priestsProvider.fetchPriests(); // Don't await to make it faster
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Consumer<AppModeProvider>(
                builder: (context, appModeProvider, child) {
                  return Text(
                    appModeProvider.modeTitle,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isAuthenticated && authProvider.isAdmin) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'مدير',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Mode toggle button
          Consumer<AppModeProvider>(
            builder: (context, appModeProvider, child) {
              return IconButton(
                icon: Icon(appModeProvider.isBishopsMode ? Icons.person : Icons.church),
                onPressed: () => _showModeSelector(),
                tooltip: 'تغيير الوضع',
              );
            },
          ),
          // Sort button
          Consumer<AppModeProvider>(
            builder: (context, appModeProvider, child) {
              if (appModeProvider.isBishopsMode) {
                return Consumer<BishopsProvider>(
                  builder: (context, bishopsProvider, child) {
                    return IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: bishopsProvider.bishops.isEmpty ? null : () => _showSortDialog(),
                      tooltip: 'ترتيب',
                    );
                  },
                );
              } else {
                return Consumer<PriestsProvider>(
                  builder: (context, priestsProvider, child) {
                    return IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: priestsProvider.priests.isEmpty ? null : () => _showSortDialog(),
                      tooltip: 'ترتيب',
                    );
                  },
                );
              }
            },
          ),
          // Attendance selection button
          Consumer<AppModeProvider>(
            builder: (context, appModeProvider, child) {
              if (appModeProvider.isBishopsMode) {
                return Consumer<BishopsProvider>(
                  builder: (context, bishopsProvider, child) {
                    return IconButton(
                      icon: const Icon(Icons.group),
                      onPressed: bishopsProvider.bishops.isEmpty ? null : () => _showAttendanceDialog(),
                      tooltip: 'اختيار الحاضرين',
                    );
                  },
                );
              } else {
                return Consumer<PriestsProvider>(
                  builder: (context, priestsProvider, child) {
                    return IconButton(
                      icon: const Icon(Icons.group),
                      onPressed: priestsProvider.priests.isEmpty ? null : () => _showPriestsAttendanceDialog(),
                      tooltip: 'اختيار الحاضرين',
                    );
                  },
                );
              }
            },
          ),
          // Simple login button
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isAuthenticated && authProvider.isAdmin) {
                return PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'مدير',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ),
                  onSelected: (value) async {
                    if (value == 'admin') {
                      final appModeProvider = Provider.of<AppModeProvider>(context, listen: false);
                      if (appModeProvider.isBishopsMode) {
                        Navigator.pushNamed(context, '/admin');
                      } else {
                        Navigator.pushNamed(context, '/priests-admin');
                      }
                    } else if (value == 'logout') {
                      await Provider.of<AuthProvider>(context, listen: false).signOut();
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'admin',
                      child: Row(
                        children: [
                          Icon(Icons.admin_panel_settings, color: Colors.deepPurple, size: 16),
                          SizedBox(width: 8),
                          Text('إدارة', style: TextStyle(fontFamily: 'Arial', fontSize: 12)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Text('خروج', style: TextStyle(fontFamily: 'Arial', fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'دخول',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Welcome Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Consumer<AppModeProvider>(
              builder: (context, appModeProvider, child) {
                return Column(
                  children: [
                    Icon(
                      appModeProvider.modeIcon,
                      size: 36,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    SafeText(
                      appModeProvider.modeTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Arial',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    SafeText(
                      appModeProvider.modeDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Arial',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          // Mode Selector
          const ModeSelectorWidget(),
          // Data List
          Expanded(
            child: Consumer<AppModeProvider>(
              builder: (context, appModeProvider, child) {
                if (appModeProvider.isBishopsMode) {
                  return _buildBishopsList();
                } else {
                  return _buildPriestsList();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBishopsList() {
    return Consumer<BishopsProvider>(
      builder: (context, bishopsProvider, child) {
        if (bishopsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          );
        }

        if (bishopsProvider.errorMessage != null) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    bishopsProvider.errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                      fontFamily: 'Arial',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      bishopsProvider.clearError();
                      bishopsProvider.fetchBishops();
                    },
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Arial'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (bishopsProvider.bishops.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.church,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد بيانات للآباء الأساقفة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم إضافة البيانات من قبل المدير',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'Arial',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // Sort Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.deepPurple[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الترتيب: ${bishopsProvider.sortBy == 'ordinationDate' ? 'تاريخ الرسامة' : 'الاسم'} ${bishopsProvider.ascending ? '(تصاعدي)' : '(تنازلي)'}',
                          style: TextStyle(
                            color: Colors.deepPurple[700],
                            fontFamily: 'Arial',
                            fontSize: 14,
                          ),
                        ),
                        if (bishopsProvider.isFiltered) ...[
                          const SizedBox(height: 4),
                          Text(
                            bishopsProvider.getFilterInfo(),
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontFamily: 'Arial',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bishops List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bishopsProvider.bishops.length,
                itemBuilder: (context, index) {
                  final bishop = bishopsProvider.bishops[index];
                  return BishopCard(bishop: bishop);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriestsList() {
    return Consumer<PriestsProvider>(
      builder: (context, priestsProvider, child) {
        if (priestsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        if (priestsProvider.errorMessage != null) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    priestsProvider.errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                      fontFamily: 'Arial',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      priestsProvider.clearError();
                      priestsProvider.fetchPriests();
                    },
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Arial'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (priestsProvider.priests.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد بيانات للآباء الكهنة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم إضافة البيانات من قبل المدير',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'Arial',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // Sort Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الترتيب: ${priestsProvider.sortBy == 'ordinationDate' ? 'تاريخ الرسامة' : 'الاسم'} ${priestsProvider.ascending ? '(تصاعدي)' : '(تنازلي)'}',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontFamily: 'Arial',
                            fontSize: 14,
                          ),
                        ),
                        if (priestsProvider.isFiltered) ...[
                          const SizedBox(height: 4),
                          Text(
                            priestsProvider.getFilterInfo(),
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontFamily: 'Arial',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Priests List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: priestsProvider.priests.length,
                itemBuilder: (context, index) {
                  final priest = priestsProvider.priests[index];
                  return PriestCard(priest: priest);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showModeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'اختيار وضع التطبيق',
          style: TextStyle(
            fontFamily: 'Arial',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const ModeSelectorWidget(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إغلاق',
              style: TextStyle(fontFamily: 'Arial'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    final appModeProvider = Provider.of<AppModeProvider>(context, listen: false);
    
    if (appModeProvider.isBishopsMode) {
      final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
      showDialog(
        context: context,
        builder: (context) => SortDialog(
          currentSortBy: bishopsProvider.sortBy,
          currentAscending: bishopsProvider.ascending,
          onSortChanged: (sortBy, ascending) {
            bishopsProvider.setSortBy(sortBy);
          },
        ),
      );
    } else {
      final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
      showDialog(
        context: context,
        builder: (context) => SortDialog(
          currentSortBy: priestsProvider.sortBy,
          currentAscending: priestsProvider.ascending,
          onSortChanged: (sortBy, ascending) {
            priestsProvider.setSortBy(sortBy);
          },
        ),
      );
    }
  }

  void _showAttendanceDialog() {
    final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
    final allBishops = bishopsProvider.allBishops;
    final selectedBishops = <String, bool>{};
    final searchController = TextEditingController();
    List<Bishop> filteredBishops = List.from(allBishops);
    
    // Initialize all bishops as not selected
    for (var bishop in allBishops) {
      selectedBishops[bishop.id] = false;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'اختيار الأساقفة الحاضرين',
            style: TextStyle(
              fontFamily: 'Arial',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث بالاسم...',
                    hintStyle: const TextStyle(fontFamily: 'Arial'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'Arial'),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        filteredBishops = List.from(allBishops);
                      } else {
                        filteredBishops = allBishops
                            .where((bishop) => bishop.name.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Bishops list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredBishops.length,
                    itemBuilder: (context, index) {
                      final bishop = filteredBishops[index];
                      return CheckboxListTile(
                        title: Text(
                          bishop.name,
                          style: const TextStyle(
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'رُسم في: ${bishop.ordinationDate.day}/${bishop.ordinationDate.month}/${bishop.ordinationDate.year}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                        value: selectedBishops[bishop.id] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedBishops[bishop.id] = value ?? false;
                          });
                        },
                        activeColor: Colors.deepPurple,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                searchController.dispose();
                Navigator.pop(context);
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'Arial'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final selectedIds = selectedBishops.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();
                
                if (selectedIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'يرجى اختيار أسقف واحد على الأقل',
                        style: TextStyle(fontFamily: 'Arial'),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                // Filter bishops to show only selected ones
                bishopsProvider.filterBishopsByIds(selectedIds);
                searchController.dispose();
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم اختيار ${selectedIds.length} من الأساقفة الحاضرين',
                      style: const TextStyle(fontFamily: 'Arial'),
                    ),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'إظهار الكل',
                      textColor: Colors.white,
                      onPressed: () {
                        bishopsProvider.clearFilter();
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'تطبيق',
                style: TextStyle(fontFamily: 'Arial'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriestsAttendanceDialog() {
    final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
    final allPriests = priestsProvider.allPriests;
    final selectedPriests = <String, bool>{};
    final searchController = TextEditingController();
    List<Priest> filteredPriests = List.from(allPriests);
    
    // Initialize all priests as not selected
    for (var priest in allPriests) {
      selectedPriests[priest.id] = false;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'اختيار الآباء الكهنة الحاضرين',
            style: TextStyle(
              fontFamily: 'Arial',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث بالاسم...',
                    hintStyle: const TextStyle(fontFamily: 'Arial'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'Arial'),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        filteredPriests = List.from(allPriests);
                      } else {
                        filteredPriests = allPriests
                            .where((priest) => priest.name.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Priests list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPriests.length,
                    itemBuilder: (context, index) {
                      final priest = filteredPriests[index];
                      return CheckboxListTile(
                        title: Text(
                          priest.name,
                          style: const TextStyle(
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'رُسم في: ${priest.ordinationDate.day}/${priest.ordinationDate.month}/${priest.ordinationDate.year}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                        value: selectedPriests[priest.id] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedPriests[priest.id] = value ?? false;
                          });
                        },
                        activeColor: Colors.blue,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                searchController.dispose();
                Navigator.pop(context);
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'Arial'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final selectedIds = selectedPriests.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();
                
                if (selectedIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'يرجى اختيار كاهن واحد على الأقل',
                        style: TextStyle(fontFamily: 'Arial'),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                // Filter priests to show only selected ones
                priestsProvider.filterPriestsByIds(selectedIds);
                searchController.dispose();
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم اختيار ${selectedIds.length} من الآباء الكهنة الحاضرين',
                      style: const TextStyle(fontFamily: 'Arial'),
                    ),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'إظهار الكل',
                      textColor: Colors.white,
                      onPressed: () {
                        priestsProvider.clearFilter();
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'تطبيق',
                style: TextStyle(fontFamily: 'Arial'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
