import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/priests_provider.dart';
import '../models/priest.dart';
import '../widgets/priest_card.dart';
import '../widgets/add_priest_dialog.dart';
import '../widgets/edit_priest_dialog.dart';
import '../widgets/sort_dialog.dart';

class PriestsAdminScreen extends StatefulWidget {
  const PriestsAdminScreen({super.key});

  @override
  State<PriestsAdminScreen> createState() => _PriestsAdminScreenState();
}

class _PriestsAdminScreenState extends State<PriestsAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PriestsProvider>(context, listen: false).fetchPriests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'إدارة الآباء الكهنة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<PriestsProvider>(
            builder: (context, priestsProvider, child) {
              return IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () => _showSortDialog(context, priestsProvider),
                tooltip: 'ترتيب القائمة',
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'home') {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (value == 'admin-management') {
                Navigator.pushNamed(context, '/admin-management');
              } else if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'home',
                child: Row(
                  children: [
                    Icon(Icons.home, color: Colors.green),
                    SizedBox(width: 8),
                    Text('الشاشة الرئيسية', style: TextStyle(fontFamily: 'Cairo')),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'admin-management',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('إدارة المدراء', style: TextStyle(fontFamily: 'Cairo')),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('تسجيل الخروج', style: TextStyle(fontFamily: 'Cairo')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPriestDialog(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'إضافة أب كاهن',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<PriestsProvider>(
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
                      fontFamily: 'Cairo',
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
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            );
          }

          if (priestsProvider.priests.isEmpty) {
            return Center(
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
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط على + لإضافة أب كاهن جديد',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPriestDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'إضافة أب كاهن جديد',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Welcome Card for Admin
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'مرحباً بك في لوحة إدارة الآباء الكهنة',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'يمكنك إضافة وتعديل وحذف بيانات الآباء الكهنة',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontFamily: 'Cairo',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                              fontFamily: 'Cairo',
                              fontSize: 14,
                            ),
                          ),
                          if (priestsProvider.isFiltered) ...[
                            const SizedBox(height: 4),
                            Text(
                              priestsProvider.getFilterInfo(),
                              style: TextStyle(
                                color: Colors.orange[800],
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
              // Priests List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: priestsProvider.priests.length,
                  itemBuilder: (context, index) {
                    final priest = priestsProvider.priests[index];
                    return PriestCard(
                      priest: priest,
                      isAdmin: true,
                      onEdit: () => _showEditPriestDialog(priest),
                      onDelete: () => _showDeletePriestDialog(priest),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddPriestDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddPriestDialog(),
    );
  }

  void _showEditPriestDialog(Priest priest) {
    showDialog(
      context: context,
      builder: (context) => EditPriestDialog(priest: priest),
    );
  }

  void _showDeletePriestDialog(Priest priest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حذف الأب الكاهن',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: Text(
          'هل أنت متأكد من حذف الأب الكاهن "${priest.name}"؟',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
              final success = await priestsProvider.deletePriest(priest.id);
              
              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم حذف الأب الكاهن "${priest.name}" بنجاح',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        priestsProvider.errorMessage ?? 'حدث خطأ في حذف الأب الكاهن',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'حذف',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context, PriestsProvider priestsProvider) {
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: const Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
