import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  static const String _languageKey = 'language_code';
  static const String _countryKey = 'country_code';

  Locale _currentLocale = const Locale('ar', 'SA');
  List<Locale> _supportedLocales = const [
    Locale('ar', 'SA'),
    Locale('en', 'US'),
  ];

  // Getters
  Locale get currentLocale => _currentLocale;
  List<Locale> get supportedLocales => _supportedLocales;
  String get currentLanguageCode => _currentLocale.languageCode;
  String get currentCountryCode => _currentLocale.countryCode ?? '';

  // Initialize language service
  Future<void> initialize() async {
    await _loadLanguageSettings();
  }

  // Load language settings from storage
  Future<void> _loadLanguageSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final languageCode = prefs.getString(_languageKey) ?? 'ar';
      final countryCode = prefs.getString(_countryKey) ?? 'SA';
      
      _currentLocale = Locale(languageCode, countryCode);
    } catch (e) {
      // Use default locale if loading fails
      _currentLocale = const Locale('ar', 'SA');
    }
  }

  // Save language settings to storage
  Future<void> _saveLanguageSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_languageKey, _currentLocale.languageCode);
      await prefs.setString(_countryKey, _currentLocale.countryCode ?? '');
    } catch (e) {
      // Handle error silently
    }
  }

  // Set current locale
  Future<void> setLocale(Locale locale) async {
    if (_supportedLocales.contains(locale)) {
      _currentLocale = locale;
      await _saveLanguageSettings();
    }
  }

  // Set language by code
  Future<void> setLanguage(String languageCode, {String? countryCode}) async {
    final locale = Locale(languageCode, countryCode);
    await setLocale(locale);
  }

  // Toggle between supported languages
  Future<void> toggleLanguage() async {
    final currentIndex = _supportedLocales.indexOf(_currentLocale);
    final nextIndex = (currentIndex + 1) % _supportedLocales.length;
    await setLocale(_supportedLocales[nextIndex]);
  }

  // Get language name
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  // Get current language name
  String getCurrentLanguageName() {
    return getLanguageName(_currentLocale);
  }

  // Get language flag emoji
  String getLanguageFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return '🇸🇦';
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'es':
        return '🇪🇸';
      case 'it':
        return '🇮🇹';
      case 'pt':
        return '🇵🇹';
      case 'ru':
        return '🇷🇺';
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      case 'ko':
        return '🇰🇷';
      default:
        return '🌐';
    }
  }

  // Get current language flag
  String getCurrentLanguageFlag() {
    return getLanguageFlag(_currentLocale);
  }

  // Check if language is RTL
  bool isRTL(Locale locale) {
    const rtlLanguages = ['ar', 'he', 'fa', 'ur', 'ku', 'dv'];
    return rtlLanguages.contains(locale.languageCode);
  }

  // Check if current language is RTL
  bool isCurrentLanguageRTL() {
    return isRTL(_currentLocale);
  }

  // Get text direction
  TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  // Get current text direction
  TextDirection getCurrentTextDirection() {
    return getTextDirection(_currentLocale);
  }

  // Get language info
  Map<String, dynamic> getLanguageInfo(Locale locale) {
    return {
      'code': locale.languageCode,
      'country': locale.countryCode,
      'name': getLanguageName(locale),
      'flag': getLanguageFlag(locale),
      'is_rtl': isRTL(locale),
      'direction': getTextDirection(locale).name,
    };
  }

  // Get current language info
  Map<String, dynamic> getCurrentLanguageInfo() {
    return getLanguageInfo(_currentLocale);
  }

  // Get all supported language info
  List<Map<String, dynamic>> getAllSupportedLanguageInfo() {
    return _supportedLocales.map((locale) => getLanguageInfo(locale)).toList();
  }

  // Add supported locale
  void addSupportedLocale(Locale locale) {
    if (!_supportedLocales.contains(locale)) {
      _supportedLocales = [..._supportedLocales, locale];
    }
  }

  // Remove supported locale
  void removeSupportedLocale(Locale locale) {
    if (_supportedLocales.length > 1) {
      _supportedLocales = _supportedLocales.where((l) => l != locale).toList();
    }
  }

  // Set supported locales
  void setSupportedLocales(List<Locale> locales) {
    if (locales.isNotEmpty) {
      _supportedLocales = locales;
    }
  }

  // Check if locale is supported
  bool isLocaleSupported(Locale locale) {
    return _supportedLocales.contains(locale);
  }

  // Get locale by language code
  Locale? getLocaleByLanguageCode(String languageCode) {
    try {
      return _supportedLocales.firstWhere(
        (locale) => locale.languageCode == languageCode,
      );
    } catch (e) {
      return null;
    }
  }

  // Get locale by country code
  Locale? getLocaleByCountryCode(String countryCode) {
    try {
      return _supportedLocales.firstWhere(
        (locale) => locale.countryCode == countryCode,
      );
    } catch (e) {
      return null;
    }
  }

  // Get system locale
  Locale getSystemLocale() {
    return WidgetsBinding.instance.platformDispatcher.locale;
  }

  // Check if current locale matches system locale
  bool isCurrentLocaleSystemLocale() {
    return _currentLocale.languageCode == getSystemLocale().languageCode;
  }

  // Set locale to system locale
  Future<void> setToSystemLocale() async {
    final systemLocale = getSystemLocale();
    if (isLocaleSupported(systemLocale)) {
      await setLocale(systemLocale);
    }
  }

  // Get language display name
  String getLanguageDisplayName(Locale locale) {
    final name = getLanguageName(locale);
    final flag = getLanguageFlag(locale);
    return '$flag $name';
  }

  // Get current language display name
  String getCurrentLanguageDisplayName() {
    return getLanguageDisplayName(_currentLocale);
  }

  // Export language settings
  Map<String, dynamic> exportLanguageSettings() {
    return {
      'language_code': _currentLocale.languageCode,
      'country_code': _currentLocale.countryCode,
      'supported_locales': _supportedLocales.map((locale) => {
        'language_code': locale.languageCode,
        'country_code': locale.countryCode,
      }).toList(),
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  // Import language settings
  Future<void> importLanguageSettings(Map<String, dynamic> settings) async {
    try {
      if (settings.containsKey('language_code')) {
        final languageCode = settings['language_code'] as String;
        final countryCode = settings['country_code'] as String?;
        final locale = Locale(languageCode, countryCode);
        
        if (isLocaleSupported(locale)) {
          await setLocale(locale);
        }
      }
      
      if (settings.containsKey('supported_locales')) {
        final localesData = settings['supported_locales'] as List<dynamic>;
        final locales = localesData.map((data) {
          final languageCode = data['language_code'] as String;
          final countryCode = data['country_code'] as String?;
          return Locale(languageCode, countryCode);
        }).toList();
        
        setSupportedLocales(locales);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Reset to default language
  Future<void> resetToDefault() async {
    _currentLocale = const Locale('ar', 'SA');
    _supportedLocales = const [
      Locale('ar', 'SA'),
      Locale('en', 'US'),
    ];
    await _saveLanguageSettings();
  }

  // Get language statistics
  Map<String, dynamic> getLanguageStatistics() {
    return {
      'current_language': getCurrentLanguageInfo(),
      'supported_count': _supportedLocales.length,
      'is_rtl': isCurrentLanguageRTL(),
      'is_system': isCurrentLocaleSystemLocale(),
      'system_language': getLanguageInfo(getSystemLocale()),
    };
  }
}