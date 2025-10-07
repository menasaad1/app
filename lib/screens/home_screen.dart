import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_mode_provider.dart';
import 'welcome_screen.dart';
import 'admin_screen.dart';
import 'priests_admin_screen.dart';
import 'admin_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          // User is authenticated, show admin screens
          return Consumer<AppModeProvider>(
            builder: (context, appModeProvider, child) {
              if (appModeProvider.isBishopsMode) {
                return const AdminScreen();
              } else {
                return const PriestsAdminScreen();
              }
            },
          );
        } else {
          // User is not authenticated, show welcome screen
          return const WelcomeScreen();
        }
      },
    );
  }
}