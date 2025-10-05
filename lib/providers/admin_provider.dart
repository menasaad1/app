import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin.dart';
import '../utils/constants.dart';

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Admin> _admins = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Admin> get admins => _admins;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAdmins() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore
          .collection('admins')
          .orderBy('createdAt', descending: true)
          .get();

      _admins = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Admin.fromMap({
              'id': doc.id,
              ...data,
            });
          })
          .toList();

    } catch (e) {
      _errorMessage = 'حدث خطأ في تحميل قائمة المدراء';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addAdmin(Admin admin) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('admins').add(admin.toMap());
      await fetchAdmins();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في إضافة المدير';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAdminWithAuth(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // First, add to admins collection
      final adminData = {
        'email': email,
        'name': name,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'createdBy': 'system', // We'll update this later
        'isActive': true,
        'password': password, // Store password temporarily for account creation
        'needsAccountCreation': true, // Flag to indicate account needs to be created
      };

      await _firestore.collection('admins').add(adminData);
      await fetchAdmins();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في إنشاء المدير: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAdmin(Admin admin) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore
          .collection('admins')
          .doc(admin.id)
          .update(admin.toMap());
      await fetchAdmins();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في تحديث المدير';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAdmin(String adminId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('admins').doc(adminId).delete();
      await fetchAdmins();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في حذف المدير';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isEmailAdmin(String email) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
