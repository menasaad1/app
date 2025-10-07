import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/bishop.dart';
import '../models/priest.dart';
import '../services/offline_service.dart';
import '../services/local_data_manager.dart';
import '../data/bishops_data.dart';
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
      
      // حفظ البيانات في الملف المحلي أيضاً
      await LocalDataManager.saveLocalBishopsData(firebaseBishops);

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
      final localBishops = await OfflineService.loadBishopsLocally();
      if (localBishops.isNotEmpty) {
        return localBishops;
      }
      
      // إذا لم توجد بيانات محلية، جرب تحميل البيانات من الملف المحلي
      final localDataBishops = await LocalDataManager.loadLocalBishopsData();
      if (localDataBishops.isNotEmpty) {
        // حفظ البيانات في OfflineService أيضاً
        await OfflineService.saveBishopsLocally(localDataBishops);
        return localDataBishops;
      }
      
      // إذا لم توجد بيانات محلية، استخدم البيانات الافتراضية
      final defaultBishops = BishopsData.getInitialBishops();
      if (defaultBishops.isNotEmpty) {
        // حفظ البيانات الافتراضية محلياً
        await OfflineService.saveBishopsLocally(defaultBishops);
        await LocalDataManager.saveLocalBishopsData(defaultBishops);
        return defaultBishops;
      }
      
      return [];
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
      return [];
    }
  }

  /// تحميل الكهنة (أونلاين أو أوفلاين)
  static Future<List<Priest>> loadPriests() async {
    try {
      if (await isOnline()) {
        // محاولة المزامنة مع Firebase
        final syncSuccess = await syncPriestsWithFirebase();
        if (syncSuccess) {
          return await OfflineService.loadPriestsLocally();
        }
      }
      
      // تحميل البيانات المحلية
      final localPriests = await OfflineService.loadPriestsLocally();
      if (localPriests.isNotEmpty) {
        return localPriests;
      }
      
      // إذا لم توجد بيانات محلية، جرب تحميل البيانات من الملف المحلي
      final localDataPriests = await LocalDataManager.loadLocalPriestsData();
      if (localDataPriests.isNotEmpty) {
        // حفظ البيانات في OfflineService أيضاً
        await OfflineService.savePriestsLocally(localDataPriests);
        return localDataPriests;
      }
      
      return [];
    } catch (e) {
      print('خطأ في تحميل الكهنة: $e');
      return [];
    }
  }

  /// إضافة أسقف (أونلاين أو أوفلاين)
  static Future<bool> addBishop(Bishop bishop) async {
    try {
      if (await isOnline()) {
        // التحقق من وجود الأسقف أولاً
        final querySnapshot = await _firestore
            .collection(AppConstants.bishopsCollection)
            .where('name', isEqualTo: bishop.name)
            .get();
        
        if (querySnapshot.docs.isEmpty) {
          // إضافة مباشرة إلى Firebase
          final bishopMap = bishop.toMap();
          bishopMap.remove('id');
          await _firestore.collection(AppConstants.bishopsCollection).add(bishopMap);
        }
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        localBishops.add(bishop);
        await OfflineService.saveBishopsLocally(localBishops);
        
        // تحديث الملف المحلي أيضاً
        await LocalDataManager.addBishopToLocalData(bishop);
        
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
        
        // تحديث الملف المحلي أيضاً
        await LocalDataManager.addBishopToLocalData(bishop);
        
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
        // البحث عن المستند في Firebase باستخدام الاسم
        final querySnapshot = await _firestore
            .collection(AppConstants.bishopsCollection)
            .where('name', isEqualTo: bishop.name)
            .get();
        
        if (querySnapshot.docs.isNotEmpty) {
          // تحديث مباشر في Firebase
          final bishopMap = bishop.toMap();
          bishopMap.remove('id');
          await querySnapshot.docs.first.reference.update(bishopMap);
        } else {
          // إذا لم يوجد المستند، أضفه جديداً
          final bishopMap = bishop.toMap();
          bishopMap.remove('id');
          await _firestore.collection(AppConstants.bishopsCollection).add(bishopMap);
        }
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        final index = localBishops.indexWhere((b) => b.id == bishop.id);
        if (index != -1) {
          localBishops[index] = bishop;
          await OfflineService.saveBishopsLocally(localBishops);
        }
        
        // تحديث الملف المحلي أيضاً
        await LocalDataManager.updateBishopInLocalData(bishop);
        
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
        
        // تحديث الملف المحلي أيضاً
        await LocalDataManager.updateBishopInLocalData(bishop);
        
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
        // البحث عن الأسقف في البيانات المحلية أولاً للحصول على الاسم
        final localBishops = await OfflineService.loadBishopsLocally();
        final bishop = localBishops.firstWhere((b) => b.id == bishopId, orElse: () => Bishop(
          id: '',
          name: '',
          diocese: '',
          ordinationDate: DateTime.now(),
          notes: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
        
        if (bishop.name.isNotEmpty) {
          // البحث عن المستند في Firebase باستخدام الاسم
          final querySnapshot = await _firestore
              .collection(AppConstants.bishopsCollection)
              .where('name', isEqualTo: bishop.name)
              .get();
          
          if (querySnapshot.docs.isNotEmpty) {
            // حذف مباشر من Firebase
            await querySnapshot.docs.first.reference.delete();
          }
        }
        
        // تحديث البيانات المحلية
        localBishops.removeWhere((b) => b.id == bishopId);
        await OfflineService.saveBishopsLocally(localBishops);
        
        // تحديث الملف المحلي أيضاً
        await LocalDataManager.deleteBishopFromLocalData(bishopId);
        
        return true;
      } else {
        // حفظ التغيير للاتصال لاحقاً
        await OfflineService.savePendingChange('delete', {'id': bishopId});
        
        // تحديث البيانات المحلية
        final localBishops = await OfflineService.loadBishopsLocally();
        localBishops.removeWhere((b) => b.id == bishopId);
        await OfflineService.saveBishopsLocally(localBishops);
        
        // تحديث الملف المحلي أيضاً
        await LocalDataManager.deleteBishopFromLocalData(bishopId);
        
        return true;
      }
    } catch (e) {
      print('خطأ في حذف الأسقف: $e');
      return false;
    }
  }

  /// مزامنة الكهنة مع Firebase
  static Future<bool> syncPriestsWithFirebase() async {
    try {
      if (!await isOnline()) {
        print('لا يوجد اتصال بالإنترنت');
        return false;
      }

      // تحميل الكهنة من Firebase
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.priestsCollection)
          .get();

      final List<Priest> firebasePriests = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Priest.fromMap({
              'id': doc.id,
              ...data,
            });
          })
          .toList();

      // حفظ البيانات محلياً
      await OfflineService.savePriestsLocally(firebasePriests);

      // تطبيق التغييرات المعلقة
      await _applyPendingChanges();

      return true;
    } catch (e) {
      print('خطأ في مزامنة الكهنة: $e');
      return false;
    }
  }

  /// إضافة كاهن (أونلاين أو أوفلاين)
  static Future<bool> addPriest(Priest priest) async {
    try {
      if (await isOnline()) {
        // إضافة مباشرة إلى Firebase
        final priestMap = priest.toMap();
        priestMap.remove('id');
        await _firestore.collection(AppConstants.priestsCollection).add(priestMap);
        
        // تحديث البيانات المحلية
        final localPriests = await OfflineService.loadPriestsLocally();
        localPriests.add(priest);
        await OfflineService.savePriestsLocally(localPriests);
        
        return true;
      } else {
        // حفظ التغيير للاتصال لاحقاً
        final priestMap = priest.toMap();
        priestMap.remove('id');
        await OfflineService.savePendingChange('add', priestMap);
        
        // إضافة إلى البيانات المحلية
        final localPriests = await OfflineService.loadPriestsLocally();
        localPriests.add(priest);
        await OfflineService.savePriestsLocally(localPriests);
        
        return true;
      }
    } catch (e) {
      print('خطأ في إضافة الكاهن: $e');
      return false;
    }
  }

  /// تحديث كاهن (أونلاين أو أوفلاين)
  static Future<bool> updatePriest(Priest priest) async {
    try {
      if (await isOnline()) {
        // تحديث مباشر في Firebase
        final priestMap = priest.toMap();
        priestMap.remove('id');
        await _firestore
            .collection(AppConstants.priestsCollection)
            .doc(priest.id)
            .update(priestMap);
        
        // تحديث البيانات المحلية
        final localPriests = await OfflineService.loadPriestsLocally();
        final index = localPriests.indexWhere((p) => p.id == priest.id);
        if (index != -1) {
          localPriests[index] = priest;
          await OfflineService.savePriestsLocally(localPriests);
        }
        
        return true;
      } else {
        // حفظ التغيير للاتصال لاحقاً
        final priestMap = priest.toMap();
        await OfflineService.savePendingChange('update', priestMap);
        
        // تحديث البيانات المحلية
        final localPriests = await OfflineService.loadPriestsLocally();
        final index = localPriests.indexWhere((p) => p.id == priest.id);
        if (index != -1) {
          localPriests[index] = priest;
          await OfflineService.savePriestsLocally(localPriests);
        }
        
        return true;
      }
    } catch (e) {
      print('خطأ في تحديث الكاهن: $e');
      return false;
    }
  }

  /// حذف كاهن (أونلاين أو أوفلاين)
  static Future<bool> deletePriest(String priestId) async {
    try {
      if (await isOnline()) {
        // حذف مباشر من Firebase
        await _firestore
            .collection(AppConstants.priestsCollection)
            .doc(priestId)
            .delete();
        
        // تحديث البيانات المحلية
        final localPriests = await OfflineService.loadPriestsLocally();
        localPriests.removeWhere((p) => p.id == priestId);
        await OfflineService.savePriestsLocally(localPriests);
        
        return true;
      } else {
        // حفظ التغيير للاتصال لاحقاً
        await OfflineService.savePendingChange('delete', {'id': priestId});
        
        // تحديث البيانات المحلية
        final localPriests = await OfflineService.loadPriestsLocally();
        localPriests.removeWhere((p) => p.id == priestId);
        await OfflineService.savePriestsLocally(localPriests);
        
        return true;
      }
    } catch (e) {
      print('خطأ في حذف الكاهن: $e');
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
