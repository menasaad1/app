import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/bishops_provider.dart';
import '../models/bishop.dart';
import '../widgets/bishop_card.dart';
import '../widgets/add_bishop_dialog.dart';
import '../widgets/edit_bishop_dialog.dart';
import '../widgets/sort_dialog.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
        title: const Text(
          'إدارة الآباء الأساقفة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<BishopsProvider>(
            builder: (context, bishopsProvider, child) {
              return IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () => _showSortDialog(context, bishopsProvider),
                tooltip: 'ترتيب القائمة',
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'admin-management') {
                Navigator.pushNamed(context, '/admin-management');
              } else if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'admin-management',
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.deepPurple),
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
        onPressed: () => _showAddBishopDialog(),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'إضافة أب أسقف',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<BishopsProvider>(
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
                            color: Colors.grey[800],
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اضغط على + لإضافة أب أسقف جديد',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontFamily: 'Cairo',
                          ),
                        ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddBishopDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'إضافة أب أسقف جديد',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
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
              // Admin Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'وضع الإدارة',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Text(
                          'يمكنك إضافة وتعديل وحذف بيانات الآباء الأساقفة',
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
                      child: Text(
                        'الترتيب: ${bishopsProvider.sortBy == 'ordinationDate' ? 'تاريخ الرسامة' : 'الاسم'} ${bishopsProvider.ascending ? '(تصاعدي)' : '(تنازلي)'}',
                        style: TextStyle(
                          color: Colors.deepPurple[700],
                          fontFamily: 'Cairo',
                          fontSize: 14,
                        ),
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
                    return BishopCard(
                      bishop: bishop,
                      isAdmin: true,
                      onEdit: () => _showEditBishopDialog(bishop),
                      onDelete: () => _showDeleteBishopDialog(bishop),
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

  void _showAddBishopDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddBishopDialog(),
    );
  }

  void _showEditBishopDialog(Bishop bishop) {
    showDialog(
      context: context,
      builder: (context) => EditBishopDialog(bishop: bishop),
    );
  }

  void _showDeleteBishopDialog(Bishop bishop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حذف الأسقف',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: Text(
          'هل أنت متأكد من حذف الأسقف "${bishop.name}"؟',
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
              final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
              final success = await bishopsProvider.deleteBishop(bishop.id);
              
              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم حذف الأسقف "${bishop.name}" بنجاح',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        bishopsProvider.errorMessage ?? 'حدث خطأ في حذف الأسقف',
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

