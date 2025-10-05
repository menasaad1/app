import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/bishops_provider.dart';
import '../models/bishop.dart';
import '../widgets/bishop_card.dart';
import '../widgets/sort_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          'قائمة الأساقفة',
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
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isAuthenticated && authProvider.isAdmin) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'admin') {
                      Navigator.pushNamed(context, '/admin');
                    } else if (value == 'logout') {
                      _showLogoutDialog();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'admin',
                      child: Row(
                        children: [
                          Icon(Icons.admin_panel_settings, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('لوحة الإدارة', style: TextStyle(fontFamily: 'Cairo')),
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
                );
              } else {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'login') {
                      Navigator.pushNamed(context, '/login');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'login',
                      child: Row(
                        children: [
                          Icon(Icons.login, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('تسجيل الدخول', style: TextStyle(fontFamily: 'Cairo')),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
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
                    'لا توجد بيانات للأساقفة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم إضافة البيانات قريباً',
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
                margin: const EdgeInsets.all(16),
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
                    return BishopCard(bishop: bishop);
                  },
                ),
              ),
            ],
          );
        },
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

