import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'network_service.dart';
import 'storage_service.dart';
import 'cache_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final NetworkService _networkService = NetworkService();
  final StorageService _storageService = StorageService();
  final CacheService _cacheService = CacheService();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool _isSyncing = false;
  final StreamController<SyncStatus> _syncController = StreamController<SyncStatus>.broadcast();
  
  // Getters
  bool get isSyncing => _isSyncing;
  Stream<SyncStatus> get syncStream => _syncController.stream;

  // Initialize sync service
  Future<void> initialize() async {
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _autoSync();
      }
    });
    
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _autoSync();
      }
    });
  }

  // Auto sync when conditions are met
  Future<void> _autoSync() async {
    if (!_isSyncing && await _shouldAutoSync()) {
      await syncData();
    }
  }

  // Check if should auto sync
  Future<bool> _shouldAutoSync() async {
    try {
      final isConnected = await _networkService.isConnected();
      final isSignedIn = _auth.currentUser != null;
      final shouldSync = await _networkService.shouldSyncData();
      
      return isConnected && isSignedIn && shouldSync;
    } catch (e) {
      return false;
    }
  }

  // Sync all data
  Future<void> syncData() async {
    if (_isSyncing) return;
    
    _isSyncing = true;
    _syncController.add(SyncStatus.started);
    
    try {
      // Check connectivity
      if (!await _networkService.isConnected()) {
        throw Exception('لا يوجد اتصال بالإنترنت');
      }
      
      // Check authentication
      if (_auth.currentUser == null) {
        throw Exception('يجب تسجيل الدخول أولاً');
      }
      
      // Sync bishops data
      await _syncBishops();
      
      // Sync dioceses data
      await _syncDioceses();
      
      // Sync user preferences
      await _syncUserPreferences();
      
      // Update last sync time
      await _updateLastSyncTime();
      
      _syncController.add(SyncStatus.completed);
    } catch (e) {
      _syncController.add(SyncStatus.failed(e.toString()));
    } finally {
      _isSyncing = false;
    }
  }

  // Sync bishops data
  Future<void> _syncBishops() async {
    try {
      _syncController.add(SyncStatus.syncing('الأساقفة'));
      
      // Get local bishops
      final localBishops = await _storageService.getBishops();
      
      // Get remote bishops
      final remoteBishops = await _getRemoteBishops();
      
      // Merge data
      final mergedBishops = _mergeBishopsData(localBishops, remoteBishops);
      
      // Update local storage
      for (final bishop in mergedBishops) {
        await _storageService.insertBishop(bishop);
      }
      
      // Update cache
      await _cacheService.cacheBishops(mergedBishops);
      
    } catch (e) {
      throw Exception('فشل في مزامنة بيانات الأساقفة: $e');
    }
  }

  // Sync dioceses data
  Future<void> _syncDioceses() async {
    try {
      _syncController.add(SyncStatus.syncing('الأبرشيات'));
      
      // Get local dioceses
      final localDioceses = await _storageService.getDioceses();
      
      // Get remote dioceses
      final remoteDioceses = await _getRemoteDioceses();
      
      // Merge data
      final mergedDioceses = _mergeDiocesesData(localDioceses, remoteDioceses);
      
      // Update local storage
      for (final diocese in mergedDioceses) {
        await _storageService.insertDiocese(diocese);
      }
      
      // Update cache
      await _cacheService.cacheDioceses(mergedDioceses);
      
    } catch (e) {
      throw Exception('فشل في مزامنة بيانات الأبرشيات: $e');
    }
  }

  // Sync user preferences
  Future<void> _syncUserPreferences() async {
    try {
      _syncController.add(SyncStatus.syncing('إعدادات المستخدم'));
      
      // Get local preferences
      final localPreferences = await _cacheService.getCachedUserPreferences();
      
      // Get remote preferences
      final remotePreferences = await _getRemoteUserPreferences();
      
      // Merge preferences
      final mergedPreferences = _mergeUserPreferences(localPreferences, remotePreferences);
      
      // Update cache
      await _cacheService.cacheUserPreferences(mergedPreferences);
      
    } catch (e) {
      throw Exception('فشل في مزامنة إعدادات المستخدم: $e');
    }
  }

  // Get remote bishops data
  Future<List<Map<String, dynamic>>> _getRemoteBishops() async {
    try {
      final snapshot = await _firestore.collection('bishops').get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      throw Exception('فشل في جلب بيانات الأساقفة من الخادم: $e');
    }
  }

  // Get remote dioceses data
  Future<List<String>> _getRemoteDioceses() async {
    try {
      final snapshot = await _firestore.collection('dioceses').get();
      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    } catch (e) {
      throw Exception('فشل في جلب بيانات الأبرشيات من الخادم: $e');
    }
  }

  // Get remote user preferences
  Future<Map<String, dynamic>?> _getRemoteUserPreferences() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  // Merge bishops data
  List<Map<String, dynamic>> _mergeBishopsData(
    List<Map<String, dynamic>> localBishops,
    List<Map<String, dynamic>> remoteBishops,
  ) {
    final mergedBishops = <Map<String, dynamic>>[];
    final localBishopsMap = {for (final bishop in localBishops) bishop['id'] as String: bishop};
    final remoteBishopsMap = {for (final bishop in remoteBishops) bishop['id'] as String: bishop};
    
    // Add all remote bishops
    for (final remoteBishop in remoteBishops) {
      final localBishop = localBishopsMap[remoteBishop['id']];
      if (localBishop != null) {
        // Merge local and remote data
        final mergedBishop = _mergeBishopData(localBishop, remoteBishop);
        mergedBishops.add(mergedBishop);
      } else {
        // Add new remote bishop
        mergedBishops.add(remoteBishop);
      }
    }
    
    // Add local bishops that don't exist remotely
    for (final localBishop in localBishops) {
      if (!remoteBishopsMap.containsKey(localBishop['id'])) {
        mergedBishops.add(localBishop);
      }
    }
    
    return mergedBishops;
  }

  // Merge dioceses data
  List<String> _mergeDiocesesData(List<String> localDioceses, List<String> remoteDioceses) {
    final mergedDioceses = <String>[];
    mergedDioceses.addAll(remoteDioceses);
    
    for (final localDiocese in localDioceses) {
      if (!mergedDioceses.contains(localDiocese)) {
        mergedDioceses.add(localDiocese);
      }
    }
    
    return mergedDioceses;
  }

  // Merge user preferences
  Map<String, dynamic> _mergeUserPreferences(
    Map<String, dynamic>? localPreferences,
    Map<String, dynamic>? remotePreferences,
  ) {
    final mergedPreferences = <String, dynamic>{};
    
    if (remotePreferences != null) {
      mergedPreferences.addAll(remotePreferences);
    }
    
    if (localPreferences != null) {
      for (final entry in localPreferences.entries) {
        if (!mergedPreferences.containsKey(entry.key)) {
          mergedPreferences[entry.key] = entry.value;
        }
      }
    }
    
    return mergedPreferences;
  }

  // Merge individual bishop data
  Map<String, dynamic> _mergeBishopData(
    Map<String, dynamic> localBishop,
    Map<String, dynamic> remoteBishop,
  ) {
    final mergedBishop = Map<String, dynamic>.from(remoteBishop);
    
    // Keep local changes that are newer
    final localUpdatedAt = localBishop['updatedAt'] as int?;
    final remoteUpdatedAt = remoteBishop['updatedAt'] as int?;
    
    if (localUpdatedAt != null && remoteUpdatedAt != null) {
      if (localUpdatedAt > remoteUpdatedAt) {
        // Local data is newer, keep local changes
        mergedBishop.addAll(localBishop);
      }
    }
    
    return mergedBishop;
  }

  // Update last sync time
  Future<void> _updateLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_sync_time', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Handle error silently
    }
  }

  // Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('last_sync_time');
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if sync is needed
  Future<bool> isSyncNeeded() async {
    try {
      final lastSync = await getLastSyncTime();
      if (lastSync == null) return true;
      
      final timeSinceLastSync = DateTime.now().difference(lastSync);
      return timeSinceLastSync > const Duration(hours: 1);
    } catch (e) {
      return true;
    }
  }

  // Force sync
  Future<void> forceSync() async {
    await syncData();
  }

  // Cancel sync
  void cancelSync() {
    if (_isSyncing) {
      _isSyncing = false;
      _syncController.add(SyncStatus.cancelled);
    }
  }

  // Get sync status
  SyncStatus getCurrentSyncStatus() {
    if (_isSyncing) {
      return SyncStatus.syncing('جاري المزامنة...');
    }
    return SyncStatus.idle;
  }

  // Dispose
  void dispose() {
    _syncController.close();
  }
}

class SyncStatus {
  final SyncStatusType type;
  final String? message;
  final String? error;

  SyncStatus._(this.type, {this.message, this.error});

  factory SyncStatus.started() => SyncStatus._(SyncStatusType.started);
  factory SyncStatus.syncing(String message) => SyncStatus._(SyncStatusType.syncing, message: message);
  factory SyncStatus.completed() => SyncStatus._(SyncStatusType.completed);
  factory SyncStatus.failed(String error) => SyncStatus._(SyncStatusType.failed, error: error);
  factory SyncStatus.cancelled() => SyncStatus._(SyncStatusType.cancelled);
  factory SyncStatus.idle() => SyncStatus._(SyncStatusType.idle);
}

enum SyncStatusType {
  idle,
  started,
  syncing,
  completed,
  failed,
  cancelled,
}
