import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PermissionWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final String? message;
  final bool requireAuth;
  final bool requireAdmin;

  const PermissionWidget({
    super.key,
    required this.child,
    this.fallback,
    this.message,
    this.requireAuth = false,
    this.requireAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Check authentication requirement
        if (requireAuth && !authProvider.isAuthenticated) {
          return fallback ?? _buildAccessDenied(context, 'يرجى تسجيل الدخول أولاً');
        }

        // Check admin requirement
        if (requireAdmin && !authProvider.isAdmin) {
          return fallback ?? _buildAccessDenied(context, message ?? 'هذه الميزة متاحة للمدير فقط');
        }

        return child;
      },
    );
  }

  Widget _buildAccessDenied(BuildContext context, String message) {
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
            message,
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

class AuthRequiredWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const AuthRequiredWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionWidget(
      requireAuth: true,
      child: child,
      fallback: fallback,
    );
  }
}

class AdminRequiredWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const AdminRequiredWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionWidget(
      requireAuth: true,
      requireAdmin: true,
      child: child,
      fallback: fallback,
    );
  }
}

class PublicWidget extends StatelessWidget {
  final Widget child;

  const PublicWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ConditionalWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final bool condition;

  const ConditionalWidget({
    super.key,
    required this.child,
    this.fallback,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return child;
    } else {
      return fallback ?? const SizedBox.shrink();
    }
  }
}
