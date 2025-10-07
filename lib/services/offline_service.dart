import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bishop.dart';
import '../models/priest.dart';

class OfflineService {
  static const String _bishopsKey = 'bishops_data';
  static const String _priestsKey = 'priests_data';
  static const String _lastSyncKey = 'last_sync_time';
  static const String _pendingChangesKey = 'pending_changes';

  /// حفظ الأساقفة محلياً
  static Future<void> saveBishopsLocally(List<Bishop> bishops) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bishopsJson = bishops.map((bishop) => bishop.toMap()).toList();
      await prefs.setString(_bishopsKey, jsonEncode(bishopsJson));
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('خطأ في حفظ البيانات محلياً: $e');
    }
  }

  /// تحميل الأساقفة من التخزين المحلي
  static Future<List<Bishop>> loadBishopsLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bishopsJson = prefs.getString(_bishopsKey);
      
      if (bishopsJson != null) {
        final List<dynamic> bishopsList = jsonDecode(bishopsJson);
        return bishopsList.map((json) => Bishop.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      print('خطأ في تحميل البيانات المحلية: $e');
      return [];
    }
  }

  /// حفظ التغييرات المعلقة
  static Future<void> savePendingChange(String action, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingChanges = await getPendingChanges();
      
      final change = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'action': action, // 'add', 'update', 'delete'
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      pendingChanges.add(change);
      await prefs.setString(_pendingChangesKey, jsonEncode(pendingChanges));
    } catch (e) {
      print('خطأ في حفظ التغيير المعلق: $e');
    }
  }

  /// الحصول على التغييرات المعلقة
  static Future<List<Map<String, dynamic>>> getPendingChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingJson = prefs.getString(_pendingChangesKey);
      
      if (pendingJson != null) {
        final List<dynamic> changesList = jsonDecode(pendingJson);
        return changesList.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('خطأ في تحميل التغييرات المعلقة: $e');
      return [];
    }
  }

  /// مسح التغييرات المعلقة
  static Future<void> clearPendingChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingChangesKey);
    } catch (e) {
      print('خطأ في مسح التغييرات المعلقة: $e');
    }
  }

  /// الحصول على آخر وقت مزامنة
  static Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncString = prefs.getString(_lastSyncKey);
      
      if (lastSyncString != null) {
        return DateTime.parse(lastSyncString);
      }
      return null;
    } catch (e) {
      print('خطأ في تحميل وقت المزامنة: $e');
      return null;
    }
  }

  /// التحقق من وجود بيانات محلية
  static Future<bool> hasLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_bishopsKey);
    } catch (e) {
      print('خطأ في التحقق من البيانات المحلية: $e');
      return false;
    }
  }

  /// حفظ الكهنة محلياً
  static Future<void> savePriestsLocally(List<Priest> priests) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final priestsJson = priests.map((priest) => priest.toMap()).toList();
      await prefs.setString(_priestsKey, jsonEncode(priestsJson));
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('خطأ في حفظ الكهنة محلياً: $e');
    }
  }

  /// تحميل الكهنة من التخزين المحلي
  static Future<List<Priest>> loadPriestsLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final priestsJson = prefs.getString(_priestsKey);
      
      if (priestsJson != null) {
        final List<dynamic> priestsList = jsonDecode(priestsJson);
        return priestsList.map((json) => Priest.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      print('خطأ في تحميل الكهنة المحلية: $e');
      return [];
    }
  }

  /// مسح جميع البيانات المحلية
  static Future<void> clearAllLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_bishopsKey);
      await prefs.remove(_priestsKey);
      await prefs.remove(_lastSyncKey);
      await prefs.remove(_pendingChangesKey);
    } catch (e) {
      print('خطأ في مسح البيانات المحلية: $e');
    }
  }
}
