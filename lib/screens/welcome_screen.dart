import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/bishops_provider.dart';
import '../widgets/bishop_card.dart';
import '../widgets/sort_dialog.dart';

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
      Provider.of<BishopsProvider>(context, listen: false).fetchBishops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'ترتيب الآباء الأساقفة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isAuthenticated && authProvider.isAdmin) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'مدير',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
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
          // Sort button
          Consumer<BishopsProvider>(
            builder: (context, bishopsProvider, child) {
              return IconButton(
                icon: const Icon(Icons.sort),
                onPressed: bishopsProvider.bishops.isEmpty ? null : () => _showSortDialog(context, bishopsProvider),
                tooltip: 'ترتيب',
              );
            },
          ),
          // Attendance selection button
          Consumer<BishopsProvider>(
            builder: (context, bishopsProvider, child) {
              return IconButton(
                icon: const Icon(Icons.group),
                onPressed: bishopsProvider.bishops.isEmpty ? null : () => _showAttendanceDialog(),
                tooltip: 'اختيار الحاضرين',
              );
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'مدير',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  onSelected: (value) async {
                    if (value == 'admin') {
                      Navigator.pushNamed(context, '/admin');
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
                          Text('إدارة', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Text('خروج', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'دخول',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
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
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
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
            child: Column(
              children: [
                const Icon(
                  Icons.church,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'ترتيب الآباء الأساقفة',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'اختر الأساقفة الحاضرين وقم بترتيبهم حسب تاريخ الرسامة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Bishops List
          Expanded(
            child: Consumer<BishopsProvider>(
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
                            fontFamily: 'Cairo',
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
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (bishopsProvider.bishops.isEmpty) {
                  return Center(
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
                            color: Colors.grey[600],
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'سيتم إضافة البيانات من قبل المدير',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
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
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                  ),
                                ),
                                if (bishopsProvider.isFiltered) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    bishopsProvider.getFilterInfo(),
                                    style: TextStyle(
                                      color: Colors.orange[700],
                                      fontFamily: 'Cairo',
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
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context, BishopsProvider bishopsProvider) {
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
  }

  void _showAttendanceDialog() {
    final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
    final allBishops = bishopsProvider.bishops;
    final selectedBishops = <String, bool>{};
    
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
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Select All / Deselect All buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            for (var key in selectedBishops.keys) {
                              selectedBishops[key] = true;
                            }
                          });
                        },
                        icon: const Icon(Icons.select_all, size: 16),
                        label: const Text(
                          'تحديد الكل',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            for (var key in selectedBishops.keys) {
                              selectedBishops[key] = false;
                            }
                          });
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text(
                          'إلغاء الكل',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Bishops list
                Expanded(
                  child: ListView.builder(
                    itemCount: allBishops.length,
                    itemBuilder: (context, index) {
                      final bishop = allBishops[index];
                      return CheckboxListTile(
                        title: Text(
                          bishop.name,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'رُسم في: ${bishop.ordinationDate.day}/${bishop.ordinationDate.month}/${bishop.ordinationDate.year}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
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
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'Cairo'),
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
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                // Filter bishops to show only selected ones
                bishopsProvider.filterBishopsByIds(selectedIds);
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم اختيار ${selectedIds.length} من الأساقفة الحاضرين',
                      style: const TextStyle(fontFamily: 'Cairo'),
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
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
