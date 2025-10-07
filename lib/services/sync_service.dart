import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/bishop.dart';
import '../services/offline_service.dart';
import '../utils/constants.dart';

class SyncService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// التحقق من الاتصال بالإنترنت
  static Future<bool> isOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('خطأ في التحقق من الاتصال: $e');
      return false;
    }
  }

  /// مزامنة البيانات مع Firebase
  static Future<bool> syncWithFirebase() async {
    try {
      if (!await isOnline()) {
        print('لا يوجد اتصال بالإنترنت');
        return false;
      }

      // تحميل البيانات من Firebase
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.bishopsCollection)
          .get();

      final List<Bishop> firebaseBishops = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Bishop.fromMap({
              'id': doc.id,
              ...data,
            });
          })
          .toList();

      // حفظ البيانات محلياً
      await OfflineService.saveBishopsLocally(firebaseBishops);

      // تطبيق التغييرات المعلقة
      await _applyPendingChanges();

      return true;
    } catch (e) {
      print('خطأ في المزامنة: $e');
      return false;
    }
  }

  /// تطبيق التغييرات المعلقة
  static Future<void> _applyPendingChanges() async {
    try {
      final pendingChanges = await OfflineService.getPendingChanges();
      
      for (final change in pendingChanges) {
        final action = change['action'] as String;
        final data = change['data'] as Map<String, dynamic>;
        
        switch (action) {
          case 'add':
            await _firestore.collection(AppConstants.bishopsCollection).add(data);
            break;
          case 'update':
            await _firestore
                .collection(AppConstants.bishopsCollection)
                .doc(data['id'])
                .update(data);
            break;
          case 'delete':
            await _firestore
                .collection(AppConstants.bishopsCollection)
                .doc(data['id'])
                .delete();
            break;
        }
      }
      
      // مسح التغييرات المعلقة بعد تطبيقها
      await OfflineService.clearPendingChanges();
    } catch (e) {
      print('خطأ في تطبيق التغييرات المعلقة: $e');
    }
  }

  /// تحميل البيانات (أونلاين أو أوفلاين)
  static Future<List<Bishop>> loadBishops() async {
    try {
      if (await isOnline()) {
        // محاولة المزامنة مع Firebase
        final syncSuccess = await syncWithFirebase();
        if (syncSuccess) {
          return await OfflineService.loadBishopsLocally();
        }
      }
      
      // تحميل البيانات المحلية
      return await OfflineService.loadBishopsLocally();
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
      return await OfflineService.loadBishopsLocally();
    }
  }

  /// إضافة أسقف (أونلاين أو أوفلاين)
  static Future<bool> addBishop(Bishop bishop) async {
    try {
      if (await isOnline()) {
        // إضافة مباشرة إلى Firebase
        final bishopMap = bishop.toMap();
        bishopMap.remove('id');
        await _firestore.collection(AppConstants.bishopsCollection).add(bishopMap);
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        localBishops.add(bishop);
        await OfflineService.saveBishopsLocally(localBishops);
        
        return true;
      } else {
        // حفظ التغيير للاتصال لاحقاً
        final bishopMap = bishop.toMap();
        bishopMap.remove('id');
        await OfflineService.savePendingChange('add', bishopMap);
        
        // إضافة إلى البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        localBishops.add(bishop);
        await OfflineService.saveBishopsLocally(localBishops);
        
        return true;
      }
    } catch (e) {
      print('خطأ في إضافة الأسقف: $e');
      return false;
    }
  }

  /// تحديث أسقف (أونلاين أو أوفلاين)
  static Future<bool> updateBishop(Bishop bishop) async {
    try {
      if (await isOnline()) {
        // تحديث مباشر في Firebase
        final bishopMap = bishop.toMap();
        bishopMap.remove('id');
        await _firestore
            .collection(AppConstants.bishopsCollection)
            .doc(bishop.id)
            .update(bishopMap);
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        final index = localBishops.indexWhere((b) => b.id == bishop.id);
        if (index != -1) {
          localBishops[index] = bishop;
          await OfflineService.saveBishopsLocally(localBishops);
        }
        
        return true;
      } else {
        // حفظ التغيير للاتصال لاحقاً
        final bishopMap = bishop.toMap();
        await OfflineService.savePendingChange('update', bishopMap);
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        final index = localBishops.indexWhere((b) => b.id == bishop.id);
        if (index != -1) {
          localBishops[index] = bishop;
          await OfflineService.saveBishopsLocally(localBishops);
        }
        
        return true;
      }
    } catch (e) {
      print('خطأ في تحديث الأسقف: $e');
      return false;
    }
  }

  /// حذف أسقف (أونلاين أو أوفلاين)
  static Future<bool> deleteBishop(String bishopId) async {
    try {
      if (await isOnline()) {
        // حذف مباشر من Firebase
        await _firestore
            .collection(AppConstants.bishopsCollection)
            .doc(bishopId)
            .delete();
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        localBishops.removeWhere((b) => b.id == bishopId);
        await OfflineService.saveBishopsLocally(localBishops);
        
        return true;
      } else {
        // حفظ التغيير للاتصال لاحقاً
        await OfflineService.savePendingChange('delete', {'id': bishopId});
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        localBishops.removeWhere((b) => b.id == bishopId);
        await OfflineService.saveBishopsLocally(localBishops);
        
        return true;
      }
    } catch (e) {
      print('خطأ في حذف الأسقف: $e');
      return false;
    }
  }

  /// مزامنة التغييرات المعلقة
  static Future<bool> syncPendingChanges() async {
    try {
      if (!await isOnline()) {
        return false;
      }

      await _applyPendingChanges();
      return true;
    } catch (e) {
      print('خطأ في مزامنة التغييرات المعلقة: $e');
      return false;
    }
  }
}
