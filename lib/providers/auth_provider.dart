import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAdmin = false;

  dynamic get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _isAdmin;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      _checkAdminStatus();
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'حدث خطأ غير متوقع';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'حدث خطأ غير متوقع';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تسجيل الخروج';
      notifyListeners();
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور خاطئة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      default:
        return 'حدث خطأ في المصادقة';
    }
  }

  Future<void> _checkAdminStatus() async {
    if (_user == null) {
      _isAdmin = false;
      return;
    }

    try {
      // Check if email is the main admin
      if (_user?.email == AppConstants.adminEmail) {
        _isAdmin = true;
        return;
      }

      // Check if email is in admins collection
      final QuerySnapshot snapshot = await _firestore
          .collection('admins')
          .where('email', isEqualTo: _user?.email)
          .where('isActive', isEqualTo: true)
          .get();

      _isAdmin = snapshot.docs.isNotEmpty;
    } catch (e) {
      _isAdmin = false;
    }
  }

  Future<bool> createAdminAccount(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Create user account
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add to admins collection
      await _firestore.collection('admins').add({
        'email': email,
        'name': name,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'createdBy': _user?.email ?? '',
        'isActive': true,
      });

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'حدث خطأ في إنشاء حساب المدير';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

