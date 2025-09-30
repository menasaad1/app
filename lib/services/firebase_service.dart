import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bishop.dart';
import '../utils/constants.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Authentication Methods
  static User? get currentUser => _auth.currentUser;
  static bool get isAuthenticated => _auth.currentUser != null;
  static bool get isAdmin => _auth.currentUser?.email == AppConstants.adminEmail;
  
  // Bishops Collection Methods
  static Future<List<Bishop>> getBishops({
    String sortBy = 'ordinationDate',
    bool ascending = true,
  }) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.bishopsCollection)
          .orderBy(sortBy, descending: !ascending)
          .get();
      
      return snapshot.docs
          .map((doc) => Bishop.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('حدث خطأ في تحميل البيانات: $e');
    }
  }
  
  static Future<String> addBishop(Bishop bishop) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.bishopsCollection)
          .add(bishop.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('حدث خطأ في إضافة الأسقف: $e');
    }
  }
  
  static Future<void> updateBishop(Bishop bishop) async {
    try {
      await _firestore
          .collection(AppConstants.bishopsCollection)
          .doc(bishop.id)
          .update(bishop.toMap());
    } catch (e) {
      throw Exception('حدث خطأ في تحديث الأسقف: $e');
    }
  }
  
  static Future<void> deleteBishop(String bishopId) async {
    try {
      await _firestore
          .collection(AppConstants.bishopsCollection)
          .doc(bishopId)
          .delete();
    } catch (e) {
      throw Exception('حدث خطأ في حذف الأسقف: $e');
    }
  }
  
  // Stream Methods for Real-time Updates
  static Stream<List<Bishop>> getBishopsStream({
    String sortBy = 'ordinationDate',
    bool ascending = true,
  }) {
    return _firestore
        .collection(AppConstants.bishopsCollection)
        .orderBy(sortBy, descending: !ascending)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Bishop.fromMap({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }
  
  // Authentication Stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}
