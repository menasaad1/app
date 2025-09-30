import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final int _maxMemoryCacheSize = 100;
  final Duration _defaultCacheExpiry = const Duration(hours: 1);

  // Initialize cache service
  Future<void> initialize() async {
    await _loadCacheFromStorage();
  }

  // Set cache value
  Future<void> setCache(String key, dynamic value, {Duration? expiry}) async {
    try {
      // Store in memory cache
      _memoryCache[key] = value;
      _cacheTimestamps[key] = DateTime.now();
      
      // Store in persistent storage
      await _saveCacheToStorage(key, value, expiry);
      
      // Clean up old cache entries
      _cleanupMemoryCache();
    } catch (e) {
      // Handle error silently
    }
  }

  // Get cache value
  Future<T?> getCache<T>(String key) async {
    try {
      // Check memory cache first
      if (_memoryCache.containsKey(key)) {
        final timestamp = _cacheTimestamps[key];
        if (timestamp != null && !_isCacheExpired(key, timestamp)) {
          return _memoryCache[key] as T?;
        } else {
          // Remove expired cache
          _memoryCache.remove(key);
          _cacheTimestamps.remove(key);
        }
      }
      
      // Check persistent storage
      final cachedValue = await _loadCacheFromStorage(key);
      if (cachedValue != null) {
        _memoryCache[key] = cachedValue;
        _cacheTimestamps[key] = DateTime.now();
        return cachedValue as T?;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if cache exists and is valid
  Future<bool> hasCache(String key) async {
    try {
      if (_memoryCache.containsKey(key)) {
        final timestamp = _cacheTimestamps[key];
        if (timestamp != null && !_isCacheExpired(key, timestamp)) {
          return true;
        }
      }
      
      final cachedValue = await _loadCacheFromStorage(key);
      return cachedValue != null;
    } catch (e) {
      return false;
    }
  }

  // Remove cache
  Future<void> removeCache(String key) async {
    try {
      _memoryCache.remove(key);
      _cacheTimestamps.remove(key);
      await _removeCacheFromStorage(key);
    } catch (e) {
      // Handle error silently
    }
  }

  // Clear all cache
  Future<void> clearCache() async {
    try {
      _memoryCache.clear();
      _cacheTimestamps.clear();
      await _clearCacheFromStorage();
    } catch (e) {
      // Handle error silently
    }
  }

  // Clear expired cache
  Future<void> clearExpiredCache() async {
    try {
      final now = DateTime.now();
      final expiredKeys = <String>[];
      
      for (final entry in _cacheTimestamps.entries) {
        if (_isCacheExpired(entry.key, entry.value)) {
          expiredKeys.add(entry.key);
        }
      }
      
      for (final key in expiredKeys) {
        _memoryCache.remove(key);
        _cacheTimestamps.remove(key);
        await _removeCacheFromStorage(key);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Get cache size
  int getCacheSize() {
    return _memoryCache.length;
  }

  // Get cache info
  Map<String, dynamic> getCacheInfo() {
    return {
      'memory_cache_size': _memoryCache.length,
      'max_memory_cache_size': _maxMemoryCacheSize,
      'cache_keys': _memoryCache.keys.toList(),
      'oldest_cache': _cacheTimestamps.values.isNotEmpty 
          ? _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b)
          : null,
      'newest_cache': _cacheTimestamps.values.isNotEmpty 
          ? _cacheTimestamps.values.reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }

  // Cache bishops data
  Future<void> cacheBishops(List<Map<String, dynamic>> bishops) async {
    await setCache('bishops', bishops, expiry: const Duration(hours: 2));
  }

  // Get cached bishops
  Future<List<Map<String, dynamic>>?> getCachedBishops() async {
    return await getCache<List<Map<String, dynamic>>>('bishops');
  }

  // Cache dioceses data
  Future<void> cacheDioceses(List<String> dioceses) async {
    await setCache('dioceses', dioceses, expiry: const Duration(hours: 4));
  }

  // Get cached dioceses
  Future<List<String>?> getCachedDioceses() async {
    return await getCache<List<String>>('dioceses');
  }

  // Cache search results
  Future<void> cacheSearchResults(String query, List<Map<String, dynamic>> results) async {
    final cacheKey = 'search_${query.hashCode}';
    await setCache(cacheKey, results, expiry: const Duration(minutes: 30));
  }

  // Get cached search results
  Future<List<Map<String, dynamic>>?> getCachedSearchResults(String query) async {
    final cacheKey = 'search_${query.hashCode}';
    return await getCache<List<Map<String, dynamic>>>(cacheKey);
  }

  // Cache user preferences
  Future<void> cacheUserPreferences(Map<String, dynamic> preferences) async {
    await setCache('user_preferences', preferences, expiry: const Duration(days: 1));
  }

  // Get cached user preferences
  Future<Map<String, dynamic>?> getCachedUserPreferences() async {
    return await getCache<Map<String, dynamic>>('user_preferences');
  }

  // Cache app settings
  Future<void> cacheAppSettings(Map<String, dynamic> settings) async {
    await setCache('app_settings', settings, expiry: const Duration(days: 7));
  }

  // Get cached app settings
  Future<Map<String, dynamic>?> getCachedAppSettings() async {
    return await getCache<Map<String, dynamic>>('app_settings');
  }

  // Cache network data
  Future<void> cacheNetworkData(String endpoint, dynamic data, {Duration? expiry}) async {
    final cacheKey = 'network_${endpoint.hashCode}';
    await setCache(cacheKey, data, expiry: expiry ?? const Duration(minutes: 15));
  }

  // Get cached network data
  Future<T?> getCachedNetworkData<T>(String endpoint) async {
    final cacheKey = 'network_${endpoint.hashCode}';
    return await getCache<T>(cacheKey);
  }

  // Cache file data
  Future<void> cacheFileData(String filePath, dynamic data) async {
    final cacheKey = 'file_${filePath.hashCode}';
    await setCache(cacheKey, data, expiry: const Duration(hours: 1));
  }

  // Get cached file data
  Future<T?> getCachedFileData<T>(String filePath) async {
    final cacheKey = 'file_${filePath.hashCode}';
    return await getCache<T>(cacheKey);
  }

  // Private methods
  bool _isCacheExpired(String key, DateTime timestamp) {
    final expiry = _getCacheExpiry(key);
    return DateTime.now().difference(timestamp) > expiry;
  }

  Duration _getCacheExpiry(String key) {
    // Different expiry times for different cache types
    if (key.startsWith('search_')) {
      return const Duration(minutes: 30);
    } else if (key.startsWith('network_')) {
      return const Duration(minutes: 15);
    } else if (key.startsWith('file_')) {
      return const Duration(hours: 1);
    } else if (key == 'bishops') {
      return const Duration(hours: 2);
    } else if (key == 'dioceses') {
      return const Duration(hours: 4);
    } else if (key == 'user_preferences') {
      return const Duration(days: 1);
    } else if (key == 'app_settings') {
      return const Duration(days: 7);
    }
    
    return _defaultCacheExpiry;
  }

  void _cleanupMemoryCache() {
    if (_memoryCache.length > _maxMemoryCacheSize) {
      // Remove oldest entries
      final sortedEntries = _cacheTimestamps.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      final entriesToRemove = sortedEntries.take(_memoryCache.length - _maxMemoryCacheSize);
      for (final entry in entriesToRemove) {
        _memoryCache.remove(entry.key);
        _cacheTimestamps.remove(entry.key);
      }
    }
  }

  Future<void> _saveCacheToStorage(String key, dynamic value, Duration? expiry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'value': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiry': expiry?.inMilliseconds ?? _defaultCacheExpiry.inMilliseconds,
      };
      
      await prefs.setString('cache_$key', jsonEncode(cacheData));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<dynamic> _loadCacheFromStorage(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheString = prefs.getString('cache_$key');
      if (cacheString == null) return null;
      
      final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(cacheData['timestamp'] as int);
      final expiry = Duration(milliseconds: cacheData['expiry'] as int);
      
      if (DateTime.now().difference(timestamp) > expiry) {
        await _removeCacheFromStorage(key);
        return null;
      }
      
      return cacheData['value'];
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_')).toList();
      
      for (final key in keys) {
        final cacheKey = key.substring(6); // Remove 'cache_' prefix
        final value = await _loadCacheFromStorage(cacheKey);
        if (value != null) {
          _memoryCache[cacheKey] = value;
          _cacheTimestamps[cacheKey] = DateTime.now();
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _removeCacheFromStorage(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cache_$key');
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _clearCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_')).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Handle error silently
    }
  }
}
