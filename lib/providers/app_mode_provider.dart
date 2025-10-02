import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppMode { bishops, priests }

class AppModeProvider with ChangeNotifier {
  AppMode _currentMode = AppMode.bishops;
  static const String _modeKey = 'app_mode';

  AppMode get currentMode => _currentMode;
  
  bool get isBishopsMode => _currentMode == AppMode.bishops;
  bool get isPriestsMode => _currentMode == AppMode.priests;

  String get modeTitle {
    switch (_currentMode) {
      case AppMode.bishops:
        return 'ترتيب الآباء الأساقفة';
      case AppMode.priests:
        return 'ترتيب الآباء الكهنة';
    }
  }

  String get modeDescription {
    switch (_currentMode) {
      case AppMode.bishops:
        return 'اختر الأساقفة الحاضرين وقم بترتيبهم حسب تاريخ الرسامة';
      case AppMode.priests:
        return 'اختر الآباء الكهنة الحاضرين وقم بترتيبهم حسب تاريخ الرسامة';
    }
  }

  String get addButtonText {
    switch (_currentMode) {
      case AppMode.bishops:
        return 'إضافة أب أسقف';
      case AppMode.priests:
        return 'إضافة أب كاهن';
    }
  }

  String get emptyMessage {
    switch (_currentMode) {
      case AppMode.bishops:
        return 'لا توجد بيانات للآباء الأساقفة';
      case AppMode.priests:
        return 'لا توجد بيانات للآباء الكهنة';
    }
  }

  String get emptySubMessage {
    switch (_currentMode) {
      case AppMode.bishops:
        return 'اضغط على + لإضافة أب أسقف جديد';
      case AppMode.priests:
        return 'اضغط على + لإضافة أب كاهن جديد';
    }
  }

  IconData get modeIcon {
    switch (_currentMode) {
      case AppMode.bishops:
        return Icons.church;
      case AppMode.priests:
        return Icons.person;
    }
  }

  // Load saved mode from SharedPreferences
  Future<void> loadMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_modeKey);
      if (savedMode != null) {
        _currentMode = AppMode.values.firstWhere(
          (mode) => mode.toString() == savedMode,
          orElse: () => AppMode.bishops,
        );
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently, use default mode
    }
  }

  // Save mode to SharedPreferences
  Future<void> _saveMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_modeKey, _currentMode.toString());
    } catch (e) {
      // Handle error silently
    }
  }

  // Switch to bishops mode
  Future<void> switchToBishops() async {
    if (_currentMode != AppMode.bishops) {
      _currentMode = AppMode.bishops;
      await _saveMode();
      notifyListeners();
    }
  }

  // Switch to priests mode
  Future<void> switchToPriests() async {
    if (_currentMode != AppMode.priests) {
      _currentMode = AppMode.priests;
      await _saveMode();
      notifyListeners();
    }
  }

  // Toggle between modes
  Future<void> toggleMode() async {
    if (_currentMode == AppMode.bishops) {
      await switchToPriests();
    } else {
      await switchToBishops();
    }
  }
}
