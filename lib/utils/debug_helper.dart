import 'package:flutter/foundation.dart';
import '../services/offline_service.dart';
import '../services/local_data_manager.dart';
import '../data/bishops_data.dart';
import '../models/bishop.dart';

class DebugHelper {
  /// طباعة معلومات التصحيح للأساقفة
  static Future<void> debugBishopsData() async {
    if (kDebugMode) {
      print('=== بدء تصحيح بيانات الأساقفة ===');
      
      // فحص البيانات المحلية
      final localBishops = await OfflineService.loadBishopsLocally();
      print('عدد الأساقفة في OfflineService: ${localBishops.length}');
      
      if (localBishops.isNotEmpty) {
        print('أول أسقف: ${localBishops.first.name}');
      }
      
      // فحص البيانات في الملف المحلي
      final localDataBishops = await LocalDataManager.loadLocalBishopsData();
      print('عدد الأساقفة في LocalDataManager: ${localDataBishops.length}');
      
      if (localDataBishops.isNotEmpty) {
        print('أول أسقف في الملف المحلي: ${localDataBishops.first.name}');
      }
      
      // فحص البيانات الافتراضية
      final defaultBishops = BishopsData.getInitialBishops();
      print('عدد الأساقفة الافتراضية: ${defaultBishops.length}');
      
      if (defaultBishops.isNotEmpty) {
        print('أول أسقف افتراضي: ${defaultBishops.first.name}');
      }
      
      print('=== انتهاء تصحيح بيانات الأساقفة ===');
    }
  }
  
  /// طباعة معلومات التصحيح للكهنة
  static Future<void> debugPriestsData() async {
    if (kDebugMode) {
      print('=== بدء تصحيح بيانات الكهنة ===');
      
      // فحص البيانات المحلية
      final localPriests = await OfflineService.loadPriestsLocally();
      print('عدد الكهنة في OfflineService: ${localPriests.length}');
      
      if (localPriests.isNotEmpty) {
        print('أول كاهن: ${localPriests.first.name}');
      }
      
      // فحص البيانات في الملف المحلي
      final localDataPriests = await LocalDataManager.loadLocalPriestsData();
      print('عدد الكهنة في LocalDataManager: ${localDataPriests.length}');
      
      if (localDataPriests.isNotEmpty) {
        print('أول كاهن في الملف المحلي: ${localDataPriests.first.name}');
      }
      
      print('=== انتهاء تصحيح بيانات الكهنة ===');
    }
  }
  
  /// إعادة تعيين البيانات للبيانات الافتراضية
  static Future<void> resetToDefaultData() async {
    if (kDebugMode) {
      print('=== إعادة تعيين البيانات للبيانات الافتراضية ===');
      
      try {
        // تحميل البيانات الافتراضية
        final defaultBishops = BishopsData.getInitialBishops();
        
        // حفظ في OfflineService
        await OfflineService.saveBishopsLocally(defaultBishops);
        print('تم حفظ ${defaultBishops.length} أسقف في OfflineService');
        
        // حفظ في LocalDataManager
        await LocalDataManager.saveLocalBishopsData(defaultBishops);
        print('تم حفظ ${defaultBishops.length} أسقف في LocalDataManager');
        
        print('=== تم إعادة تعيين البيانات بنجاح ===');
      } catch (e) {
        print('خطأ في إعادة تعيين البيانات: $e');
      }
    }
  }
}
