import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static const String _themeKey = 'theme_mode';
  static const String _accentColorKey = 'accent_color';
  static const String _fontSizeKey = 'font_size';
  static const String _fontFamilyKey = 'font_family';

  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = const Color(0xFF2E7D32);
  double _fontSize = 14.0;
  String _fontFamily = 'Cairo';

  // Getters
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;

  // Initialize theme service
  Future<void> initialize() async {
    await _loadThemeSettings();
  }

  // Load theme settings from storage
  Future<void> _loadThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final themeModeIndex = prefs.getInt(_themeKey) ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
      
      // Load accent color
      final accentColorValue = prefs.getInt(_accentColorKey) ?? 0xFF2E7D32;
      _accentColor = Color(accentColorValue);
      
      // Load font size
      _fontSize = prefs.getDouble(_fontSizeKey) ?? 14.0;
      
      // Load font family
      _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Cairo';
    } catch (e) {
      // Use default values if loading fails
      _themeMode = ThemeMode.system;
      _accentColor = const Color(0xFF2E7D32);
      _fontSize = 14.0;
      _fontFamily = 'Cairo';
    }
  }

  // Save theme settings to storage
  Future<void> _saveThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setInt(_themeKey, _themeMode.index);
      await prefs.setInt(_accentColorKey, _accentColor.value);
      await prefs.setDouble(_fontSizeKey, _fontSize);
      await prefs.setString(_fontFamilyKey, _fontFamily);
    } catch (e) {
      // Handle error silently
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveThemeSettings();
  }

  // Set accent color
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    await _saveThemeSettings();
  }

  // Set font size
  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _saveThemeSettings();
  }

  // Set font family
  Future<void> setFontFamily(String family) async {
    _fontFamily = family;
    await _saveThemeSettings();
  }

  // Toggle theme mode
  Future<void> toggleThemeMode() async {
    switch (_themeMode) {
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        await setThemeMode(ThemeMode.light);
        break;
    }
  }

  // Get theme mode name
  String getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.dark:
        return 'داكن';
      case ThemeMode.system:
        return 'نظام التشغيل';
    }
  }

  // Get available accent colors
  List<Color> getAvailableAccentColors() {
    return [
      const Color(0xFF2E7D32), // Green
      const Color(0xFF1976D2), // Blue
      const Color(0xFFD32F2F), // Red
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFFF57C00), // Orange
      const Color(0xFF00ACC1), // Cyan
      const Color(0xFF8BC34A), // Light Green
      const Color(0xFFFF9800), // Amber
    ];
  }

  // Get available font families
  List<String> getAvailableFontFamilies() {
    return [
      'Cairo',
      'Arial',
      'Helvetica',
      'Times New Roman',
      'Courier New',
      'Georgia',
      'Verdana',
      'Trebuchet MS',
    ];
  }

  // Get available font sizes
  List<double> getAvailableFontSizes() {
    return [12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0, 26.0, 28.0, 30.0];
  }

  // Get font size name
  String getFontSizeName(double size) {
    if (size <= 12) return 'صغير جداً';
    if (size <= 14) return 'صغير';
    if (size <= 16) return 'متوسط';
    if (size <= 18) return 'كبير';
    if (size <= 20) return 'كبير جداً';
    if (size <= 22) return 'ضخم';
    if (size <= 24) return 'ضخم جداً';
    return 'عملاق';
  }

  // Reset to default theme
  Future<void> resetToDefault() async {
    _themeMode = ThemeMode.system;
    _accentColor = const Color(0xFF2E7D32);
    _fontSize = 14.0;
    _fontFamily = 'Cairo';
    await _saveThemeSettings();
  }

  // Get theme data
  ThemeData getThemeData(BuildContext context) {
    final isDark = _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      textTheme: Theme.of(context).textTheme.apply(
        fontFamily: _fontFamily,
        fontSizeFactor: _fontSize / 14.0,
      ),
    );
  }

  // Get dark theme data
  ThemeData getDarkThemeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: Brightness.dark,
      ),
    );
  }

  // Get light theme data
  ThemeData getLightThemeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: Brightness.light,
      ),
    );
  }

  // Check if dark mode is enabled
  bool isDarkMode(BuildContext context) {
    return _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
  }

  // Check if light mode is enabled
  bool isLightMode(BuildContext context) {
    return _themeMode == ThemeMode.light ||
        (_themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.light);
  }

  // Check if system mode is enabled
  bool isSystemMode() {
    return _themeMode == ThemeMode.system;
  }

  // Get theme mode icon
  IconData getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_suggest;
    }
  }

  // Get accent color name
  String getAccentColorName(Color color) {
    if (color.value == 0xFF2E7D32) return 'أخضر';
    if (color.value == 0xFF1976D2) return 'أزرق';
    if (color.value == 0xFFD32F2F) return 'أحمر';
    if (color.value == 0xFF7B1FA2) return 'بنفسجي';
    if (color.value == 0xFFF57C00) return 'برتقالي';
    if (color.value == 0xFF00ACC1) return 'سماوي';
    if (color.value == 0xFF8BC34A) return 'أخضر فاتح';
    if (color.value == 0xFFFF9800) return 'عنبر';
    return 'مخصص';
  }

  // Export theme settings
  Map<String, dynamic> exportThemeSettings() {
    return {
      'theme_mode': _themeMode.index,
      'accent_color': _accentColor.value,
      'font_size': _fontSize,
      'font_family': _fontFamily,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  // Import theme settings
  Future<void> importThemeSettings(Map<String, dynamic> settings) async {
    try {
      if (settings.containsKey('theme_mode')) {
        final modeIndex = settings['theme_mode'] as int;
        if (modeIndex >= 0 && modeIndex < ThemeMode.values.length) {
          _themeMode = ThemeMode.values[modeIndex];
        }
      }
      
      if (settings.containsKey('accent_color')) {
        final colorValue = settings['accent_color'] as int;
        _accentColor = Color(colorValue);
      }
      
      if (settings.containsKey('font_size')) {
        final size = settings['font_size'] as double;
        if (size >= 8.0 && size <= 48.0) {
          _fontSize = size;
        }
      }
      
      if (settings.containsKey('font_family')) {
        final family = settings['font_family'] as String;
        if (getAvailableFontFamilies().contains(family)) {
          _fontFamily = family;
        }
      }
      
      await _saveThemeSettings();
    } catch (e) {
      // Handle error silently
    }
  }
}