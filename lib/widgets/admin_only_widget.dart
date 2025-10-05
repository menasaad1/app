import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AdminOnlyWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final String? message;

  const AdminOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated && authProvider.isAdmin) {
          return child;
        } else {
          return fallback ?? _buildAccessDenied(context);
        }
      },
    );
  }

  Widget _buildAccessDenied(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'هذه الميزة متاحة للمدير فقط',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(Icons.login),
            label: const Text(
              'تسجيل الدخول',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminOnlyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;

  const AdminOnlyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated && authProvider.isAdmin) {
          return Tooltip(
            message: tooltip ?? '',
            child: child,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class AdminOnlyFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;

  const AdminOnlyFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated && authProvider.isAdmin) {
          return FloatingActionButton(
            onPressed: onPressed,
            tooltip: tooltip,
            child: child,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
