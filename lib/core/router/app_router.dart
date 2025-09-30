import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/bishops/presentation/pages/bishops_page.dart';
import '../../features/bishops/presentation/pages/bishop_details_page.dart';
import '../../features/bishops/presentation/pages/add_edit_bishop_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../core/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.when(
        data: (user) => user != null,
        loading: () => false,
        error: (_, __) => false,
      );
      
      final isSplash = state.location == '/splash';
      final isLogin = state.location == '/login';
      
      if (!isLoggedIn && !isSplash && !isLogin) {
        return '/login';
      }
      
      if (isLoggedIn && (isSplash || isLogin)) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Main App Routes
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home Route
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          
          // Bishops Routes
          GoRoute(
            path: '/bishops',
            name: 'bishops',
            builder: (context, state) => const BishopsPage(),
            routes: [
              GoRoute(
                path: '/add',
                name: 'addBishop',
                builder: (context, state) => const AddEditBishopPage(),
              ),
              GoRoute(
                path: '/:id',
                name: 'bishopDetails',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return BishopDetailsPage(bishopId: id);
                },
                routes: [
                  GoRoute(
                    path: '/edit',
                    name: 'editBishop',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return AddEditBishopPage(bishopId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          
          // Reports Route
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsPage(),
          ),
          
          // Settings Route
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});

class MainShell extends StatelessWidget {
  final Widget child;
  
  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'الأساقفة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'التقارير',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).location;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/bishops')) return 1;
    if (location.startsWith('/reports')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/bishops');
        break;
      case 2:
        context.go('/reports');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }
}
