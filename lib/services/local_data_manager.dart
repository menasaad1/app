import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bishop.dart';
import '../models/priest.dart';
import '../data/bishops_data.dart';

class LocalDataManager {
  static const String _bishopsDataKey = 'bishops_data_file';
  static const String _priestsDataKey = 'priests_data_file';
  static const String _lastUpdateKey = 'last_data_update';

  /// تحميل البيانات المحلية للأساقفة
  static Future<List<Bishop>> loadLocalBishopsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bishopsJson = prefs.getString(_bishopsDataKey);
      
      if (bishopsJson != null) {
        final List<dynamic> bishopsList = jsonDecode(bishopsJson);
        return bishopsList.map((json) => Bishop.fromMap(json)).toList();
      } else {
        // إذا لم توجد بيانات محلية، استخدم البيانات الافتراضية
        return BishopsData.getInitialBishops();
      }
    } catch (e) {
      print('خطأ في تحميل البيانات المحلية للأساقفة: $e');
      return BishopsData.getInitialBishops();
    }
  }

  /// حفظ البيانات المحلية للأساقفة
  static Future<void> saveLocalBishopsData(List<Bishop> bishops) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bishopsJson = bishops.map((bishop) => bishop.toMap()).toList();
      await prefs.setString(_bishopsDataKey, jsonEncode(bishopsJson));
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      print('تم حفظ ${bishops.length} أسقف في البيانات المحلية');
    } catch (e) {
      print('خطأ في حفظ البيانات المحلية للأساقفة: $e');
    }
  }

  /// تحميل البيانات المحلية للكهنة
  static Future<List<Priest>> loadLocalPriestsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final priestsJson = prefs.getString(_priestsDataKey);
      
      if (priestsJson != null) {
        final List<dynamic> priestsList = jsonDecode(priestsJson);
        return priestsList.map((json) => Priest.fromMap(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('خطأ في تحميل البيانات المحلية للكهنة: $e');
      return [];
    }
  }

  /// حفظ البيانات المحلية للكهنة
  static Future<void> saveLocalPriestsData(List<Priest> priests) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final priestsJson = priests.map((priest) => priest.toMap()).toList();
      await prefs.setString(_priestsDataKey, jsonEncode(priestsJson));
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      print('تم حفظ ${priests.length} كاهن في البيانات المحلية');
    } catch (e) {
      print('خطأ في حفظ البيانات المحلية للكهنة: $e');
    }
  }

  /// إضافة أسقف جديد للبيانات المحلية
  static Future<void> addBishopToLocalData(Bishop bishop) async {
    try {
      final bishops = await loadLocalBishopsData();
      bishops.add(bishop);
      await saveLocalBishopsData(bishops);
    } catch (e) {
      print('خطأ في إضافة الأسقف للبيانات المحلية: $e');
    }
  }

  /// تحديث أسقف في البيانات المحلية
  static Future<void> updateBishopInLocalData(Bishop updatedBishop) async {
    try {
      final bishops = await loadLocalBishopsData();
      final index = bishops.indexWhere((bishop) => bishop.id == updatedBishop.id);
      
      if (index != -1) {
        bishops[index] = updatedBishop;
        await saveLocalBishopsData(bishops);
        print('تم تحديث الأسقف في البيانات المحلية: ${updatedBishop.name}');
      } else {
        print('لم يتم العثور على الأسقف في البيانات المحلية: ${updatedBishop.name}');
      }
    } catch (e) {
      print('خطأ في تحديث الأسقف في البيانات المحلية: $e');
    }
  }

  /// حذف أسقف من البيانات المحلية
  static Future<void> deleteBishopFromLocalData(String bishopId) async {
    try {
      final bishops = await loadLocalBishopsData();
      bishops.removeWhere((bishop) => bishop.id == bishopId);
      await saveLocalBishopsData(bishops);
      print('تم حذف الأسقف من البيانات المحلية: $bishopId');
    } catch (e) {
      print('خطأ في حذف الأسقف من البيانات المحلية: $e');
    }
  }

  /// إضافة كاهن جديد للبيانات المحلية
  static Future<void> addPriestToLocalData(Priest priest) async {
    try {
      final priests = await loadLocalPriestsData();
      priests.add(priest);
      await saveLocalPriestsData(priests);
    } catch (e) {
      print('خطأ في إضافة الكاهن للبيانات المحلية: $e');
    }
  }

  /// تحديث كاهن في البيانات المحلية
  static Future<void> updatePriestInLocalData(Priest updatedPriest) async {
    try {
      final priests = await loadLocalPriestsData();
      final index = priests.indexWhere((priest) => priest.id == updatedPriest.id);
      
      if (index != -1) {
        priests[index] = updatedPriest;
        await saveLocalPriestsData(priests);
        print('تم تحديث الكاهن في البيانات المحلية: ${updatedPriest.name}');
      } else {
        print('لم يتم العثور على الكاهن في البيانات المحلية: ${updatedPriest.name}');
      }
    } catch (e) {
      print('خطأ في تحديث الكاهن في البيانات المحلية: $e');
    }
  }

  /// حذف كاهن من البيانات المحلية
  static Future<void> deletePriestFromLocalData(String priestId) async {
    try {
      final priests = await loadLocalPriestsData();
      priests.removeWhere((priest) => priest.id == priestId);
      await saveLocalPriestsData(priests);
      print('تم حذف الكاهن من البيانات المحلية: $priestId');
    } catch (e) {
      print('خطأ في حذف الكاهن من البيانات المحلية: $e');
    }
  }

  /// إعادة تعيين البيانات المحلية للبيانات الافتراضية
  static Future<void> resetToDefaultData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_bishopsDataKey);
      await prefs.remove(_priestsDataKey);
      await prefs.remove(_lastUpdateKey);
      print('تم إعادة تعيين البيانات المحلية للبيانات الافتراضية');
    } catch (e) {
      print('خطأ في إعادة تعيين البيانات المحلية: $e');
    }
  }

  /// الحصول على آخر وقت تحديث
  static Future<DateTime?> getLastUpdateTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdateString = prefs.getString(_lastUpdateKey);
      
      if (lastUpdateString != null) {
        return DateTime.parse(lastUpdateString);
      }
      return null;
    } catch (e) {
      print('خطأ في الحصول على وقت آخر تحديث: $e');
      return null;
    }
  }

  /// الحصول على عدد الأساقفة المحليين
  static Future<int> getLocalBishopsCount() async {
    try {
      final bishops = await loadLocalBishopsData();
      return bishops.length;
    } catch (e) {
      return 0;
    }
  }

  /// الحصول على عدد الكهنة المحليين
  static Future<int> getLocalPriestsCount() async {
    try {
      final priests = await loadLocalPriestsData();
      return priests.length;
    } catch (e) {
      return 0;
    }
  }

  /// مسح جميع البيانات المحلية
  static Future<void> clearAllLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_bishopsDataKey);
      await prefs.remove(_priestsDataKey);
      await prefs.remove(_lastUpdateKey);
      print('تم مسح جميع البيانات المحلية');
    } catch (e) {
      print('خطأ في مسح البيانات المحلية: $e');
    }
  }
}
