import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_config.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/bishops_provider.dart';
import 'providers/priests_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/app_mode_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/priests_admin_screen.dart';
import 'screens/admin_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling for Flutter Web
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log error but don't crash the app
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  
  // Handle platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    debugPrint('Stack trace: $stack');
    return true; // Handled
  };
  
  await FirebaseConfig.initialize();
  runApp(const BishopsApp());
}

class BishopsApp extends StatelessWidget {
  const BishopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BishopsProvider()),
        ChangeNotifierProvider(create: (_) => PriestsProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => AppModeProvider()),
      ],
      child: MaterialApp(
        title: 'ترتيب الآباء الأساقفة',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        locale: const Locale('ar', 'SA'),
        theme: AppTheme.lightTheme.copyWith(
          textTheme: AppTheme.lightTheme.textTheme.apply(
            fontFamily: 'Arial',
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
        ),
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const WelcomeScreen(),
          '/admin': (context) => const AdminScreen(),
          '/priests-admin': (context) => const PriestsAdminScreen(),
          '/admin-management': (context) => const AdminManagementScreen(),
        },
      ),
    );
  }
}

