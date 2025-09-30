import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get signUp => _localizedValues[locale.languageCode]!['signUp']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get name => _localizedValues[locale.languageCode]!['name']!;
  String get ordinationDate => _localizedValues[locale.languageCode]!['ordinationDate']!;
  String get diocese => _localizedValues[locale.languageCode]!['diocese']!;
  String get notes => _localizedValues[locale.languageCode]!['notes']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get bishopsList => _localizedValues[locale.languageCode]!['bishopsList']!;
  String get adminPanel => _localizedValues[locale.languageCode]!['adminPanel']!;
  String get sortBy => _localizedValues[locale.languageCode]!['sortBy']!;
  String get sortByName => _localizedValues[locale.languageCode]!['sortByName']!;
  String get sortByDate => _localizedValues[locale.languageCode]!['sortByDate']!;
  String get ascending => _localizedValues[locale.languageCode]!['ascending']!;
  String get descending => _localizedValues[locale.languageCode]!['descending']!;
  String get noData => _localizedValues[locale.languageCode]!['noData']!;
  String get addBishop => _localizedValues[locale.languageCode]!['addBishop']!;
  String get editBishop => _localizedValues[locale.languageCode]!['editBishop']!;
  String get deleteBishop => _localizedValues[locale.languageCode]!['deleteBishop']!;
  String get bishopAdded => _localizedValues[locale.languageCode]!['bishopAdded']!;
  String get bishopUpdated => _localizedValues[locale.languageCode]!['bishopUpdated']!;
  String get bishopDeleted => _localizedValues[locale.languageCode]!['bishopDeleted']!;
  String get confirmDelete => _localizedValues[locale.languageCode]!['confirmDelete']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get confirmLogout => _localizedValues[locale.languageCode]!['confirmLogout']!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appTitle': 'إدارة الأساقفة',
      'login': 'تسجيل الدخول',
      'signUp': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'name': 'الاسم',
      'ordinationDate': 'تاريخ الرسامة',
      'diocese': 'الأسقفية',
      'notes': 'ملاحظات',
      'add': 'إضافة',
      'edit': 'تعديل',
      'delete': 'حذف',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'bishopsList': 'قائمة الأساقفة',
      'adminPanel': 'لوحة الإدارة',
      'sortBy': 'ترتيب حسب',
      'sortByName': 'الاسم',
      'sortByDate': 'تاريخ الرسامة',
      'ascending': 'تصاعدي',
      'descending': 'تنازلي',
      'noData': 'لا توجد بيانات',
      'addBishop': 'إضافة أسقف',
      'editBishop': 'تعديل الأسقف',
      'deleteBishop': 'حذف الأسقف',
      'bishopAdded': 'تم إضافة الأسقف بنجاح',
      'bishopUpdated': 'تم تحديث الأسقف بنجاح',
      'bishopDeleted': 'تم حذف الأسقف بنجاح',
      'confirmDelete': 'هل أنت متأكد من الحذف؟',
      'logout': 'تسجيل الخروج',
      'confirmLogout': 'هل أنت متأكد من تسجيل الخروج؟',
    },
    'en': {
      'appTitle': 'Bishops Management',
      'login': 'Login',
      'signUp': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'ordinationDate': 'Ordination Date',
      'diocese': 'Diocese',
      'notes': 'Notes',
      'add': 'Add',
      'edit': 'Edit',
      'delete': 'Delete',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'bishopsList': 'Bishops List',
      'adminPanel': 'Admin Panel',
      'sortBy': 'Sort By',
      'sortByName': 'Name',
      'sortByDate': 'Ordination Date',
      'ascending': 'Ascending',
      'descending': 'Descending',
      'noData': 'No Data',
      'addBishop': 'Add Bishop',
      'editBishop': 'Edit Bishop',
      'deleteBishop': 'Delete Bishop',
      'bishopAdded': 'Bishop added successfully',
      'bishopUpdated': 'Bishop updated successfully',
      'bishopDeleted': 'Bishop deleted successfully',
      'confirmDelete': 'Are you sure you want to delete?',
      'logout': 'Logout',
      'confirmLogout': 'Are you sure you want to logout?',
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

