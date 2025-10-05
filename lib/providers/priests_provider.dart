import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/priest.dart';
import '../utils/constants.dart';

class PriestsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Priest> _priests = [];
  List<Priest> _allPriests = []; // Store all priests for filtering
  List<String> _filteredIds = []; // Store filtered priest IDs
  bool _isFiltered = false;
  bool _isLoading = false;
  String? _errorMessage;
  String _sortBy = 'ordinationDate'; // 'name' or 'ordinationDate'
  bool _ascending = true;

  List<Priest> get priests => _priests;
  List<Priest> get allPriests => _allPriests;
  bool get isLoading => _isLoading;
  bool get isFiltered => _isFiltered;
  String? get errorMessage => _errorMessage;
  String get sortBy => _sortBy;
  bool get ascending => _ascending;

  Future<void> fetchPriests() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Try cache first for better performance
      QuerySnapshot snapshot;
      try {
        snapshot = await _firestore
            .collection(AppConstants.priestsCollection)
            .get(const GetOptions(source: Source.cache));
      } catch (e) {
        // Fallback to network if cache fails
        snapshot = await _firestore
            .collection(AppConstants.priestsCollection)
            .get();
      }

      _allPriests = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Priest.fromMap({
              'id': doc.id,
              ...data,
            });
          })
          .toList();
      
      // Apply current filter if exists
      if (_isFiltered && _filteredIds.isNotEmpty) {
        _priests = _allPriests.where((priest) => _filteredIds.contains(priest.id)).toList();
      } else {
        _priests = List.from(_allPriests);
        _isFiltered = false; // Reset filter if showing all
      }
      
      _sortPriests();

    } catch (e) {
      _errorMessage = 'حدث خطأ في تحميل البيانات';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPriest(Priest priest) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final priestMap = priest.toMap();
      priestMap.remove('id'); // Remove id from map before adding
      
      await _firestore.collection(AppConstants.priestsCollection).add(priestMap);
      await fetchPriests();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في إضافة الأب الكاهن: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePriest(Priest priest) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final priestMap = priest.toMap();
      priestMap.remove('id'); // Remove id from map before updating
      
      await _firestore
          .collection(AppConstants.priestsCollection)
          .doc(priest.id)
          .update(priestMap);
      await fetchPriests();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في تحديث الأب الكاهن: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePriest(String priestId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection(AppConstants.priestsCollection).doc(priestId).delete();
      
      // Remove from filtered list if it exists
      if (_isFiltered) {
        _filteredIds.remove(priestId);
      }
      
      await fetchPriests();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ في حذف الأب الكاهن: ${e.toString()}';
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
    fetchPriests();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _sortPriests() {
    _priests.sort((a, b) {
      int comparison;
      if (_sortBy == 'name') {
        comparison = a.name.compareTo(b.name);
      } else {
        comparison = a.ordinationDate.compareTo(b.ordinationDate);
      }
      return _ascending ? comparison : -comparison;
    });
  }

  // Filter priests by selected IDs (for attendance)
  void filterPriestsByIds(List<String> selectedIds) {
    _filteredIds = selectedIds;
    _isFiltered = true;
    _priests = _allPriests.where((priest) => selectedIds.contains(priest.id)).toList();
    _sortPriests();
    notifyListeners();
  }

  // Clear filter and show all priests
  void clearFilter() {
    _isFiltered = false;
    _filteredIds.clear();
    _priests = List.from(_allPriests);
    _sortPriests();
    notifyListeners();
  }

  // Get filtered status info
  String getFilterInfo() {
    if (_isFiltered) {
      return 'عرض ${_priests.length} من ${_allPriests.length} كاهن';
    }
    return 'عرض جميع الآباء الكهنة (${_allPriests.length})';
  }
}
