import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bishop.dart';
import '../utils/constants.dart';

class BishopsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Bishop> _bishops = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _sortBy = 'ordinationDate'; // 'name' or 'ordinationDate'
  bool _ascending = true;

  List<Bishop> get bishops => _bishops;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get sortBy => _sortBy;
  bool get ascending => _ascending;

  BishopsProvider() {
    fetchBishops();
  }

  Future<void> fetchBishops() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.bishopsCollection)
          .orderBy(_sortBy, descending: !_ascending)
          .get();

      _bishops = snapshot.docs
          .map((doc) => Bishop.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

    } catch (e) {
      _errorMessage = 'حدث خطأ في تحميل البيانات';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addBishop(Bishop bishop) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection(AppConstants.bishopsCollection).add(bishop.toMap());
      await fetchBishops();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في إضافة الأسقف';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBishop(Bishop bishop) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore
          .collection(AppConstants.bishopsCollection)
          .doc(bishop.id)
          .update(bishop.toMap());
      await fetchBishops();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في تحديث الأسقف';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBishop(String bishopId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection(AppConstants.bishopsCollection).doc(bishopId).delete();
      await fetchBishops();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في حذف الأسقف';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSortBy(String sortBy) {
    if (_sortBy != sortBy) {
      _sortBy = sortBy;
      _ascending = true;
    } else {
      _ascending = !_ascending;
    }
    fetchBishops();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

