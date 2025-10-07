import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bishop.dart';
import '../utils/constants.dart';
import '../services/sync_service.dart';
import '../services/offline_service.dart';

class BishopsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Bishop> _bishops = [];
  List<Bishop> _allBishops = []; // Store all bishops for filtering
  List<String> _filteredIds = []; // Store filtered bishop IDs
  bool _isFiltered = false;
  bool _isLoading = false;
  String? _errorMessage;
  String _sortBy = 'ordinationDate'; // 'name' or 'ordinationDate'
  bool _ascending = true;

  List<Bishop> get bishops => _bishops;
  List<Bishop> get allBishops => _allBishops;
  bool get isLoading => _isLoading;
  bool get isFiltered => _isFiltered;
  String? get errorMessage => _errorMessage;
  String get sortBy => _sortBy;
  bool get ascending => _ascending;

  Future<void> fetchBishops() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // استخدام خدمة المزامنة الجديدة
      _allBishops = await SyncService.loadBishops();
      
      // Apply current filter if exists
      if (_isFiltered && _filteredIds.isNotEmpty) {
        _bishops = _allBishops.where((bishop) => _filteredIds.contains(bishop.id)).toList();
      } else {
        _bishops = List.from(_allBishops);
        _isFiltered = false; // Reset filter if showing all
      }
      
      _sortBishops();

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

      // استخدام خدمة المزامنة الجديدة
      final success = await SyncService.addBishop(bishop);
      
      if (success) {
        await fetchBishops();
        return true;
      } else {
        _errorMessage = 'حدث خطأ في إضافة الأسقف';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ في إضافة الأسقف: ${e.toString()}';
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

      // استخدام خدمة المزامنة الجديدة
      final success = await SyncService.updateBishop(bishop);
      
      if (success) {
        await fetchBishops();
        return true;
      } else {
        _errorMessage = 'حدث خطأ في تحديث الأسقف';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ في تحديث الأسقف: ${e.toString()}';
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

      // استخدام خدمة المزامنة الجديدة
      final success = await SyncService.deleteBishop(bishopId);
      
      if (success) {
        // Remove from filtered list if it exists
        if (_isFiltered) {
          _filteredIds.remove(bishopId);
        }
        
        await fetchBishops();
        return true;
      } else {
        _errorMessage = 'حدث خطأ في حذف الأسقف';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ في حذف الأسقف: ${e.toString()}';
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

  void _sortBishops() {
    _bishops.sort((a, b) {
      int comparison;
      if (_sortBy == 'name') {
        comparison = a.name.compareTo(b.name);
      } else {
        comparison = a.ordinationDate.compareTo(b.ordinationDate);
      }
      return _ascending ? comparison : -comparison;
    });
  }

  // Filter bishops by selected IDs (for attendance)
  void filterBishopsByIds(List<String> selectedIds) {
    _filteredIds = selectedIds;
    _isFiltered = true;
    _bishops = _allBishops.where((bishop) => selectedIds.contains(bishop.id)).toList();
    _sortBishops();
    notifyListeners();
  }

  // Clear filter and show all bishops
  void clearFilter() {
    _isFiltered = false;
    _filteredIds.clear();
    _bishops = List.from(_allBishops);
    _sortBishops();
    notifyListeners();
  }

  // Get filtered status info
  String getFilterInfo() {
    if (_isFiltered) {
      return 'عرض ${_bishops.length} من ${_allBishops.length} أسقف';
    }
    return 'عرض جميع الأساقفة (${_allBishops.length})';
  }

  // مزامنة التغييرات المعلقة
  Future<bool> syncPendingChanges() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await SyncService.syncPendingChanges();
      
      if (success) {
        await fetchBishops();
        return true;
      } else {
        _errorMessage = 'فشل في مزامنة التغييرات';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ في المزامنة: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // التحقق من وجود تغييرات معلقة
  Future<bool> hasPendingChanges() async {
    try {
      final pendingChanges = await OfflineService.getPendingChanges();
      return pendingChanges.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // الحصول على عدد التغييرات المعلقة
  Future<int> getPendingChangesCount() async {
    try {
      final pendingChanges = await OfflineService.getPendingChanges();
      return pendingChanges.length;
    } catch (e) {
      return 0;
    }
  }
}

