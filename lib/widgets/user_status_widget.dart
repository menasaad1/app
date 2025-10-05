import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class UserStatusWidget extends StatelessWidget {
  const UserStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return _buildAuthenticatedUser(context, authProvider);
        } else {
          return _buildGuestUser(context);
        }
      },
    );
  }

  Widget _buildAuthenticatedUser(BuildContext context, AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: authProvider.isAdmin ? Colors.deepPurple : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            authProvider.isAdmin ? Icons.admin_panel_settings : Icons.person,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            authProvider.isAdmin ? 'مدير' : 'مستخدم',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestUser(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'زائر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return _buildUserInfo(context, authProvider);
        } else {
          return _buildGuestInfo(context);
        }
      },
    );
  }

  Widget _buildUserInfo(BuildContext context, AuthProvider authProvider) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  authProvider.isAdmin ? Icons.admin_panel_settings : Icons.person,
                  color: authProvider.isAdmin ? Colors.deepPurple : Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.isAdmin ? 'مدير النظام' : 'مستخدم',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: authProvider.isAdmin ? Colors.deepPurple : Colors.green,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (authProvider.user?.email != null)
                        Text(
                          authProvider.user!.email!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Cairo',
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  tooltip: 'تسجيل الخروج',
                ),
              ],
            ),
            if (authProvider.isAdmin) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.deepPurple[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.deepPurple[700],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'يمكنك إضافة وتعديل وحذف بيانات الأساقفة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple[700],
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuestInfo(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'زائر',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        'يمكنك تصفح قائمة الأساقفة فقط',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  icon: const Icon(Icons.login, size: 16),
                  label: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 12, fontFamily: 'Cairo'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'للوصول إلى لوحة الإدارة، يرجى تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
