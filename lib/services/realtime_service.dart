import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/bishop.dart';
import '../models/priest.dart';
import '../services/offline_service.dart';
import '../services/local_data_manager.dart';
import '../utils/constants.dart';

class RealtimeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static StreamSubscription<QuerySnapshot>? _bishopsSubscription;
  static StreamSubscription<QuerySnapshot>? _priestsSubscription;
  
  // Callbacks for data updates
  static Function(List<Bishop>)? onBishopsUpdated;
  static Function(List<Priest>)? onPriestsUpdated;
  static Function(String)? onError;

  /// بدء الاستماع لتحديثات الأساقفة
  static void startBishopsListener() {
    _bishopsSubscription?.cancel();
    
    _bishopsSubscription = _firestore
        .collection(AppConstants.bishopsCollection)
        .snapshots()
        .listen(
          (snapshot) async {
            try {
              final bishops = snapshot.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Bishop.fromMap({
                      'id': doc.id,
                      ...data,
                    });
                  })
                  .toList();

              // حفظ البيانات محلياً
              await OfflineService.saveBishopsLocally(bishops);
              
              // حفظ البيانات في الملف المحلي أيضاً
              await LocalDataManager.saveLocalBishopsData(bishops);
              
              // إشعار التطبيق بالتحديث
              if (onBishopsUpdated != null) {
                onBishopsUpdated!(bishops);
              }
              
              print('تم تحديث بيانات الأساقفة: ${bishops.length} أسقف');
            } catch (e) {
              print('خطأ في تحديث بيانات الأساقفة: $e');
              if (onError != null) {
                onError!('خطأ في تحديث بيانات الأساقفة: $e');
              }
            }
          },
          onError: (error) {
            print('خطأ في الاستماع لتحديثات الأساقفة: $error');
            if (onError != null) {
              onError!('خطأ في الاستماع لتحديثات الأساقفة: $error');
            }
          },
        );
  }

  /// بدء الاستماع لتحديثات الكهنة
  static void startPriestsListener() {
    _priestsSubscription?.cancel();
    
    _priestsSubscription = _firestore
        .collection(AppConstants.priestsCollection)
        .snapshots()
        .listen(
          (snapshot) async {
            try {
              final priests = snapshot.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Priest.fromMap({
                      'id': doc.id,
                      ...data,
                    });
                  })
                  .toList();

              // حفظ البيانات محلياً
              await OfflineService.savePriestsLocally(priests);
              
              // حفظ البيانات في الملف المحلي أيضاً
              await LocalDataManager.saveLocalPriestsData(priests);
              
              // إشعار التطبيق بالتحديث
              if (onPriestsUpdated != null) {
                onPriestsUpdated!(priests);
              }
              
              print('تم تحديث بيانات الكهنة: ${priests.length} كاهن');
            } catch (e) {
              print('خطأ في تحديث بيانات الكهنة: $e');
              if (onError != null) {
                onError!('خطأ في تحديث بيانات الكهنة: $e');
              }
            }
          },
          onError: (error) {
            print('خطأ في الاستماع لتحديثات الكهنة: $error');
            if (onError != null) {
              onError!('خطأ في الاستماع لتحديثات الكهنة: $error');
            }
          },
        );
  }

  /// إيقاف جميع المستمعين
  static void stopAllListeners() {
    _bishopsSubscription?.cancel();
    _priestsSubscription?.cancel();
    _bishopsSubscription = null;
    _priestsSubscription = null;
  }

  /// التحقق من الاتصال بالإنترنت
  static Future<bool> isOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// بدء الاستماع للتحديثات (للأساقفة والكهنة)
  static void startRealtimeUpdates({
    Function(List<Bishop>)? onBishopsUpdate,
    Function(List<Priest>)? onPriestsUpdate,
    Function(String)? onError,
  }) {
    // تعيين callbacks
    RealtimeService.onBishopsUpdated = onBishopsUpdate;
    RealtimeService.onPriestsUpdated = onPriestsUpdate;
    RealtimeService.onError = onError;

    // بدء الاستماع
    startBishopsListener();
    startPriestsListener();
  }

  /// إيقاف التحديثات المباشرة
  static void stopRealtimeUpdates() {
    stopAllListeners();
    onBishopsUpdated = null;
    onPriestsUpdated = null;
    onError = null;
  }
}
