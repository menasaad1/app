import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ar', 'SA'),
    Locale('en', 'US'),
  ];

  // Common
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get filter => _localizedValues[locale.languageCode]!['filter']!;
  String get clear => _localizedValues[locale.languageCode]!['clear']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get yes => _localizedValues[locale.languageCode]!['yes']!;
  String get no => _localizedValues[locale.languageCode]!['no']!;
  String get back => _localizedValues[locale.languageCode]!['back']!;
  String get next => _localizedValues[locale.languageCode]!['next']!;
  String get previous => _localizedValues[locale.languageCode]!['previous']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get done => _localizedValues[locale.languageCode]!['done']!;
  String get refresh => _localizedValues[locale.languageCode]!['refresh']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get noData => _localizedValues[locale.languageCode]!['noData']!;
  String get noResults => _localizedValues[locale.languageCode]!['noResults']!;
  String get tryAgain => _localizedValues[locale.languageCode]!['tryAgain']!;

  // Navigation
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get bishops => _localizedValues[locale.languageCode]!['bishops']!;
  String get reports => _localizedValues[locale.languageCode]!['reports']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;

  // Bishop Management
  String get addBishop => _localizedValues[locale.languageCode]!['addBishop']!;
  String get editBishop => _localizedValues[locale.languageCode]!['editBishop']!;
  String get deleteBishop => _localizedValues[locale.languageCode]!['deleteBishop']!;
  String get bishopDetails => _localizedValues[locale.languageCode]!['bishopDetails']!;
  String get bishopName => _localizedValues[locale.languageCode]!['bishopName']!;
  String get bishopTitle => _localizedValues[locale.languageCode]!['bishopTitle']!;
  String get diocese => _localizedValues[locale.languageCode]!['diocese']!;
  String get ordinationDate => _localizedValues[locale.languageCode]!['ordinationDate']!;
  String get birthDate => _localizedValues[locale.languageCode]!['birthDate']!;
  String get phoneNumber => _localizedValues[locale.languageCode]!['phoneNumber']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get address => _localizedValues[locale.languageCode]!['address']!;
  String get biography => _localizedValues[locale.languageCode]!['biography']!;
  String get photo => _localizedValues[locale.languageCode]!['photo']!;
  String get selectPhoto => _localizedValues[locale.languageCode]!['selectPhoto']!;
  String get takePhoto => _localizedValues[locale.languageCode]!['takePhoto']!;
  String get chooseFromGallery => _localizedValues[locale.languageCode]!['chooseFromGallery']!;

  // Search and Filter
  String get searchBishops => _localizedValues[locale.languageCode]!['searchBishops']!;
  String get filterByDiocese => _localizedValues[locale.languageCode]!['filterByDiocese']!;
  String get filterByDate => _localizedValues[locale.languageCode]!['filterByDate']!;
  String get sortBy => _localizedValues[locale.languageCode]!['sortBy']!;
  String get sortByName => _localizedValues[locale.languageCode]!['sortByName']!;
  String get sortByDate => _localizedValues[locale.languageCode]!['sortByDate']!;
  String get sortByDiocese => _localizedValues[locale.languageCode]!['sortByDiocese']!;
  String get ascending => _localizedValues[locale.languageCode]!['ascending']!;
  String get descending => _localizedValues[locale.languageCode]!['descending']!;

  // Reports
  String get generateReport => _localizedValues[locale.languageCode]!['generateReport']!;
  String get exportToPdf => _localizedValues[locale.languageCode]!['exportToPdf']!;
  String get exportToExcel => _localizedValues[locale.languageCode]!['exportToExcel']!;
  String get printReport => _localizedValues[locale.languageCode]!['printReport']!;
  String get totalBishops => _localizedValues[locale.languageCode]!['totalBishops']!;
  String get bishopsByDiocese => _localizedValues[locale.languageCode]!['bishopsByDiocese']!;
  String get statistics => _localizedValues[locale.languageCode]!['statistics']!;

  // Settings
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get lightTheme => _localizedValues[locale.languageCode]!['lightTheme']!;
  String get darkTheme => _localizedValues[locale.languageCode]!['darkTheme']!;
  String get systemTheme => _localizedValues[locale.languageCode]!['systemTheme']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;

  // Validation Messages
  String get requiredField => _localizedValues[locale.languageCode]!['requiredField']!;
  String get invalidEmail => _localizedValues[locale.languageCode]!['invalidEmail']!;
  String get invalidPhone => _localizedValues[locale.languageCode]!['invalidPhone']!;
  String get invalidDate => _localizedValues[locale.languageCode]!['invalidDate']!;
  String get nameTooShort => _localizedValues[locale.languageCode]!['nameTooShort']!;
  String get nameTooLong => _localizedValues[locale.languageCode]!['nameTooLong']!;

  // Success Messages
  String get bishopAddedSuccessfully => _localizedValues[locale.languageCode]!['bishopAddedSuccessfully']!;
  String get bishopUpdatedSuccessfully => _localizedValues[locale.languageCode]!['bishopUpdatedSuccessfully']!;
  String get bishopDeletedSuccessfully => _localizedValues[locale.languageCode]!['bishopDeletedSuccessfully']!;
  String get reportGeneratedSuccessfully => _localizedValues[locale.languageCode]!['reportGeneratedSuccessfully']!;

  // Error Messages
  String get failedToAddBishop => _localizedValues[locale.languageCode]!['failedToAddBishop']!;
  String get failedToUpdateBishop => _localizedValues[locale.languageCode]!['failedToUpdateBishop']!;
  String get failedToDeleteBishop => _localizedValues[locale.languageCode]!['failedToDeleteBishop']!;
  String get failedToLoadBishops => _localizedValues[locale.languageCode]!['failedToLoadBishops']!;
  String get failedToGenerateReport => _localizedValues[locale.languageCode]!['failedToGenerateReport']!;
  String get networkError => _localizedValues[locale.languageCode]!['networkError']!;
  String get permissionDenied => _localizedValues[locale.languageCode]!['permissionDenied']!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      // Common
      'appTitle': 'تطبيق إدارة الأساقفة',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'search': 'بحث',
      'filter': 'تصفية',
      'clear': 'مسح',
      'confirm': 'تأكيد',
      'yes': 'نعم',
      'no': 'لا',
      'back': 'رجوع',
      'next': 'التالي',
      'previous': 'السابق',
      'close': 'إغلاق',
      'done': 'تم',
      'refresh': 'تحديث',
      'retry': 'إعادة المحاولة',
      'noData': 'لا توجد بيانات',
      'noResults': 'لا توجد نتائج',
      'tryAgain': 'حاول مرة أخرى',

      // Navigation
      'home': 'الرئيسية',
      'bishops': 'الأساقفة',
      'reports': 'التقارير',
      'settings': 'الإعدادات',
      'profile': 'الملف الشخصي',

      // Bishop Management
      'addBishop': 'إضافة أسقف',
      'editBishop': 'تعديل الأسقف',
      'deleteBishop': 'حذف الأسقف',
      'bishopDetails': 'تفاصيل الأسقف',
      'bishopName': 'اسم الأسقف',
      'bishopTitle': 'لقب الأسقف',
      'diocese': 'الأبرشية',
      'ordinationDate': 'تاريخ الرسامة',
      'birthDate': 'تاريخ الميلاد',
      'phoneNumber': 'رقم الهاتف',
      'email': 'البريد الإلكتروني',
      'address': 'العنوان',
      'biography': 'السيرة الذاتية',
      'photo': 'الصورة',
      'selectPhoto': 'اختيار صورة',
      'takePhoto': 'التقاط صورة',
      'chooseFromGallery': 'اختيار من المعرض',

      // Search and Filter
      'searchBishops': 'البحث في الأساقفة',
      'filterByDiocese': 'تصفية حسب الأبرشية',
      'filterByDate': 'تصفية حسب التاريخ',
      'sortBy': 'ترتيب حسب',
      'sortByName': 'الاسم',
      'sortByDate': 'التاريخ',
      'sortByDiocese': 'الأبرشية',
      'ascending': 'تصاعدي',
      'descending': 'تنازلي',

      // Reports
      'generateReport': 'إنشاء تقرير',
      'exportToPdf': 'تصدير إلى PDF',
      'exportToExcel': 'تصدير إلى Excel',
      'printReport': 'طباعة التقرير',
      'totalBishops': 'إجمالي الأساقفة',
      'bishopsByDiocese': 'الأساقفة حسب الأبرشية',
      'statistics': 'الإحصائيات',

      // Settings
      'language': 'اللغة',
      'theme': 'المظهر',
      'lightTheme': 'فاتح',
      'darkTheme': 'داكن',
      'systemTheme': 'نظام التشغيل',
      'notifications': 'الإشعارات',
      'about': 'حول التطبيق',
      'version': 'الإصدار',
      'logout': 'تسجيل الخروج',

      // Validation Messages
      'requiredField': 'هذا الحقل مطلوب',
      'invalidEmail': 'البريد الإلكتروني غير صحيح',
      'invalidPhone': 'رقم الهاتف غير صحيح',
      'invalidDate': 'التاريخ غير صحيح',
      'nameTooShort': 'الاسم قصير جداً',
      'nameTooLong': 'الاسم طويل جداً',

      // Success Messages
      'bishopAddedSuccessfully': 'تم إضافة الأسقف بنجاح',
      'bishopUpdatedSuccessfully': 'تم تحديث الأسقف بنجاح',
      'bishopDeletedSuccessfully': 'تم حذف الأسقف بنجاح',
      'reportGeneratedSuccessfully': 'تم إنشاء التقرير بنجاح',

      // Error Messages
      'failedToAddBishop': 'فشل في إضافة الأسقف',
      'failedToUpdateBishop': 'فشل في تحديث الأسقف',
      'failedToDeleteBishop': 'فشل في حذف الأسقف',
      'failedToLoadBishops': 'فشل في تحميل الأساقفة',
      'failedToGenerateReport': 'فشل في إنشاء التقرير',
      'networkError': 'خطأ في الشبكة',
      'permissionDenied': 'تم رفض الإذن',
    },
    'en': {
      // Common
      'appTitle': 'Bishops Management App',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'filter': 'Filter',
      'clear': 'Clear',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'close': 'Close',
      'done': 'Done',
      'refresh': 'Refresh',
      'retry': 'Retry',
      'noData': 'No Data',
      'noResults': 'No Results',
      'tryAgain': 'Try Again',

      // Navigation
      'home': 'Home',
      'bishops': 'Bishops',
      'reports': 'Reports',
      'settings': 'Settings',
      'profile': 'Profile',

      // Bishop Management
      'addBishop': 'Add Bishop',
      'editBishop': 'Edit Bishop',
      'deleteBishop': 'Delete Bishop',
      'bishopDetails': 'Bishop Details',
      'bishopName': 'Bishop Name',
      'bishopTitle': 'Bishop Title',
      'diocese': 'Diocese',
      'ordinationDate': 'Ordination Date',
      'birthDate': 'Birth Date',
      'phoneNumber': 'Phone Number',
      'email': 'Email',
      'address': 'Address',
      'biography': 'Biography',
      'photo': 'Photo',
      'selectPhoto': 'Select Photo',
      'takePhoto': 'Take Photo',
      'chooseFromGallery': 'Choose from Gallery',

      // Search and Filter
      'searchBishops': 'Search Bishops',
      'filterByDiocese': 'Filter by Diocese',
      'filterByDate': 'Filter by Date',
      'sortBy': 'Sort by',
      'sortByName': 'Name',
      'sortByDate': 'Date',
      'sortByDiocese': 'Diocese',
      'ascending': 'Ascending',
      'descending': 'Descending',

      // Reports
      'generateReport': 'Generate Report',
      'exportToPdf': 'Export to PDF',
      'exportToExcel': 'Export to Excel',
      'printReport': 'Print Report',
      'totalBishops': 'Total Bishops',
      'bishopsByDiocese': 'Bishops by Diocese',
      'statistics': 'Statistics',

      // Settings
      'language': 'Language',
      'theme': 'Theme',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'systemTheme': 'System',
      'notifications': 'Notifications',
      'about': 'About',
      'version': 'Version',
      'logout': 'Logout',

      // Validation Messages
      'requiredField': 'This field is required',
      'invalidEmail': 'Invalid email address',
      'invalidPhone': 'Invalid phone number',
      'invalidDate': 'Invalid date',
      'nameTooShort': 'Name is too short',
      'nameTooLong': 'Name is too long',

      // Success Messages
      'bishopAddedSuccessfully': 'Bishop added successfully',
      'bishopUpdatedSuccessfully': 'Bishop updated successfully',
      'bishopDeletedSuccessfully': 'Bishop deleted successfully',
      'reportGeneratedSuccessfully': 'Report generated successfully',

      // Error Messages
      'failedToAddBishop': 'Failed to add bishop',
      'failedToUpdateBishop': 'Failed to update bishop',
      'failedToDeleteBishop': 'Failed to delete bishop',
      'failedToLoadBishops': 'Failed to load bishops',
      'failedToGenerateReport': 'Failed to generate report',
      'networkError': 'Network error',
      'permissionDenied': 'Permission denied',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
