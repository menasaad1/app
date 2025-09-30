class AppConstants {
  // App Information
  static const String appName = 'تطبيق إدارة الأساقفة';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Firebase Collections
  static const String bishopsCollection = 'bishops';
  static const String diocesesCollection = 'dioceses';
  static const String usersCollection = 'users';

  // Storage Paths
  static const String bishopsPhotosPath = 'bishops';
  static const String reportsPath = 'reports';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image Settings
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const int imageQuality = 85;

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // Date Ranges
  static const int minYear = 1900;
  static const int maxYear = 2100;

  // Search
  static const int minSearchLength = 2;
  static const int maxSearchResults = 50;

  // Cache
  static const int cacheExpirationDays = 7;
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Chart Colors
  static const List<int> chartColors = [
    0xFF2E7D32, // Primary Green
    0xFF1976D2, // Blue
    0xFFF57C00, // Orange
    0xFFD32F2F, // Red
    0xFF7B1FA2, // Purple
    0xFF00ACC1, // Cyan
    0xFF8BC34A, // Light Green
    0xFFFF9800, // Amber
  ];

  // Error Messages
  static const String networkErrorMessage = 'خطأ في الاتصال بالشبكة';
  static const String serverErrorMessage = 'خطأ في الخادم';
  static const String unknownErrorMessage = 'حدث خطأ غير متوقع';
  static const String permissionDeniedMessage = 'تم رفض الإذن';
  static const String fileNotFoundMessage = 'الملف غير موجود';
  static const String invalidDataMessage = 'البيانات غير صحيحة';

  // Success Messages
  static const String dataSavedMessage = 'تم حفظ البيانات بنجاح';
  static const String dataUpdatedMessage = 'تم تحديث البيانات بنجاح';
  static const String dataDeletedMessage = 'تم حذف البيانات بنجاح';
  static const String operationCompletedMessage = 'تمت العملية بنجاح';

  // Default Values
  static const String defaultLanguage = 'ar';
  static const String defaultTheme = 'system';
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultTimeFormat = 'HH:mm';

  // API Endpoints (if needed)
  static const String baseUrl = 'https://api.bishops-app.com';
  static const String apiVersion = 'v1';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Limits
  static const int maxBishopsPerDiocese = 1000;
  static const int maxDioceses = 100;
  static const int maxReportSize = 10 * 1024 * 1024; // 10MB

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration downloadTimeout = Duration(minutes: 10);

  // Regular Expressions
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^[0-9+\-\s()]+$';
  static const String nameRegex = r'^[a-zA-Z\u0600-\u06FF\s]+$';

  // File Extensions
  static const List<String> supportedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> supportedDocumentExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];

  // Database
  static const String databaseName = 'bishops.db';
  static const int databaseVersion = 1;

  // Notifications
  static const String notificationChannelId = 'bishops_notifications';
  static const String notificationChannelName = 'إشعارات الأساقفة';
  static const String notificationChannelDescription = 'إشعارات تطبيق إدارة الأساقفة';
}
