class AppConstants {
  // Firebase Collections
  static const String bishopsCollection = 'bishops';
  static const String priestsCollection = 'priests';
  static const String usersCollection = 'users';
  
  // Admin Configuration
  static const String adminEmail = 'admin@bishops.com';
  
  // App Configuration
  static const String appName = 'إدارة الأساقفة';
  static const String appVersion = '1.0.0';
  
  // Date Formats
  static const String dateFormat = 'yyyy/MM/dd';
  static const String dateTimeFormat = 'yyyy/MM/dd HH:mm';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 100;
  static const int maxNotesLength = 500;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;
  
  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
