import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _sortByKey = 'sort_by';
  static const String _ascendingKey = 'ascending';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Sort Preferences
  static String getSortBy() {
    return _prefs?.getString(_sortByKey) ?? 'ordinationDate';
  }
  
  static Future<void> setSortBy(String sortBy) async {
    await _prefs?.setString(_sortByKey, sortBy);
  }
  
  static bool getAscending() {
    return _prefs?.getBool(_ascendingKey) ?? true;
  }
  
  static Future<void> setAscending(bool ascending) async {
    await _prefs?.setBool(_ascendingKey, ascending);
  }
  
  // Theme Preferences
  static String getThemeMode() {
    return _prefs?.getString(_themeKey) ?? 'system';
  }
  
  static Future<void> setThemeMode(String themeMode) async {
    await _prefs?.setString(_themeKey, themeMode);
  }
  
  // Language Preferences
  static String getLanguage() {
    return _prefs?.getString(_languageKey) ?? 'ar';
  }
  
  static Future<void> setLanguage(String language) async {
    await _prefs?.setString(_languageKey, language);
  }
  
  // Clear all preferences
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}