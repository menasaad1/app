import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/bishops_data.dart';
import '../models/bishop.dart';

class FirebaseDataLoader {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة جميع الأساقفة إلى Firebase
  static Future<void> loadBishopsToFirebase() async {
    try {
      final bishops = BishopsData.getInitialBishops();
      
      // حذف البيانات الموجودة أولاً
      await _clearExistingBishops();
      
      // إضافة الأساقفة الجدد
      for (int i = 0; i < bishops.length; i++) {
        final bishop = bishops[i];
        await _firestore.collection('bishops').add({
          'id': bishop.id,
          'name': bishop.name,
          'diocese': bishop.diocese,
          'ordinationDate': Timestamp.fromDate(bishop.ordinationDate),
          'notes': bishop.notes,
          'createdAt': Timestamp.fromDate(bishop.createdAt),
          'updatedAt': Timestamp.fromDate(bishop.updatedAt),
        });
        
        print('تم إضافة الأسقف ${i + 1}/${bishops.length}: ${bishop.name}');
      }
      
      print('تم إضافة جميع الأساقفة بنجاح!');
    } catch (e) {
      print('خطأ في إضافة الأساقفة: $e');
      rethrow;
    }
  }

  /// حذف الأساقفة الموجودة
  static Future<void> _clearExistingBishops() async {
    try {
      final querySnapshot = await _firestore.collection('bishops').get();
      final batch = _firestore.batch();
      
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      print('تم حذف الأساقفة الموجودة');
    } catch (e) {
      print('خطأ في حذف الأساقفة الموجودة: $e');
    }
  }

  /// إضافة أسقف واحد
  static Future<void> addSingleBishop(Bishop bishop) async {
    try {
      await _firestore.collection('bishops').add({
        'id': bishop.id,
        'name': bishop.name,
        'diocese': bishop.diocese,
        'ordinationDate': Timestamp.fromDate(bishop.ordinationDate),
        'notes': bishop.notes,
        'createdAt': Timestamp.fromDate(bishop.createdAt),
        'updatedAt': Timestamp.fromDate(bishop.updatedAt),
      });
      print('تم إضافة الأسقف: ${bishop.name}');
    } catch (e) {
      print('خطأ في إضافة الأسقف: $e');
      rethrow;
    }
  }

  /// الحصول على عدد الأساقفة
  static Future<int> getBishopsCount() async {
    try {
      final querySnapshot = await _firestore.collection('bishops').get();
      return querySnapshot.docs.length;
    } catch (e) {
      print('خطأ في الحصول على عدد الأساقفة: $e');
      return 0;
    }
  }
}
