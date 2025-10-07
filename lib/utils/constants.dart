class AppConstants {
  // Firebase Collections
  static const String bishopsCollection = 'bishops';
  static const String priestsCollection = 'priests';
  static const String adminsCollection = 'admins';
  
  // Admin Configuration
  static const String adminEmail = 'admin@bishops.com';
  
  // SharedPreferences Keys
  static const String userEmailKey = 'user_email';
  static const String isAdminKey = 'is_admin';
  static const String appModeKey = 'app_mode'; // 'bishops' or 'priests'
  
  // App Modes
  static const String bishopsMode = 'bishops';
  static const String priestsMode = 'priests';
  
  // Sort Options
  static const String sortByName = 'name';
  static const String sortByOrdinationDate = 'ordinationDate';
  
  // Error Messages
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String dataLoadError = 'خطأ في تحميل البيانات';
  static const String dataSaveError = 'خطأ في حفظ البيانات';
  static const String dataDeleteError = 'خطأ في حذف البيانات';
  
  // Success Messages
  static const String dataLoadSuccess = 'تم تحميل البيانات بنجاح';
  static const String dataSaveSuccess = 'تم حفظ البيانات بنجاح';
  static const String dataDeleteSuccess = 'تم حذف البيانات بنجاح';
  static const String syncSuccess = 'تم مزامنة البيانات بنجاح';
}