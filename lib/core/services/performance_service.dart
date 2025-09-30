import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<int>> _measurements = {};

  // Start a performance timer
  void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  // Stop a performance timer and record the measurement
  int stopTimer(String name) {
    final timer = _timers[name];
    if (timer == null) return 0;
    
    timer.stop();
    final duration = timer.elapsedMilliseconds;
    
    // Record the measurement
    _measurements.putIfAbsent(name, () => []);
    _measurements[name]!.add(duration);
    
    // Remove the timer
    _timers.remove(name);
    
    return duration;
  }

  // Get average time for a specific operation
  double getAverageTime(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) return 0.0;
    
    final sum = measurements.reduce((a, b) => a + b);
    return sum / measurements.length;
  }

  // Get minimum time for a specific operation
  int getMinTime(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) return 0;
    
    return measurements.reduce((a, b) => a < b ? a : b);
  }

  // Get maximum time for a specific operation
  int getMaxTime(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) return 0;
    
    return measurements.reduce((a, b) => a > b ? a : b);
  }

  // Get total count of measurements for a specific operation
  int getMeasurementCount(String name) {
    final measurements = _measurements[name];
    return measurements?.length ?? 0;
  }

  // Get all performance metrics
  Map<String, Map<String, dynamic>> getAllMetrics() {
    final metrics = <String, Map<String, dynamic>>{};
    
    for (final entry in _measurements.entries) {
      final name = entry.key;
      final measurements = entry.value;
      
      if (measurements.isNotEmpty) {
        final sum = measurements.reduce((a, b) => a + b);
        final average = sum / measurements.length;
        final min = measurements.reduce((a, b) => a < b ? a : b);
        final max = measurements.reduce((a, b) => a > b ? a : b);
        
        metrics[name] = {
          'count': measurements.length,
          'average': average,
          'min': min,
          'max': max,
          'total': sum,
        };
      }
    }
    
    return metrics;
  }

  // Clear all measurements
  void clearMetrics() {
    _measurements.clear();
    _timers.clear();
  }

  // Clear measurements for a specific operation
  void clearMetricsFor(String name) {
    _measurements.remove(name);
    _timers.remove(name);
  }

  // Measure a function execution time
  Future<T> measureFunction<T>(
    String name,
    Future<T> Function() function,
  ) async {
    startTimer(name);
    try {
      final result = await function();
      stopTimer(name);
      return result;
    } catch (e) {
      stopTimer(name);
      rethrow;
    }
  }

  // Measure a synchronous function execution time
  T measureSyncFunction<T>(
    String name,
    T Function() function,
  ) {
    startTimer(name);
    try {
      final result = function();
      stopTimer(name);
      return result;
    } catch (e) {
      stopTimer(name);
      rethrow;
    }
  }

  // Get memory usage information
  Future<Map<String, dynamic>> getMemoryUsage() async {
    try {
      final info = await ProcessInfo.currentRss;
      return {
        'rss': info,
        'rss_mb': (info / 1024 / 1024).toStringAsFixed(2),
      };
    } catch (e) {
      return {
        'rss': 0,
        'rss_mb': '0.00',
        'error': e.toString(),
      };
    }
  }

  // Get CPU usage information
  Future<Map<String, dynamic>> getCpuUsage() async {
    try {
      // This is a simplified CPU usage calculation
      // In a real app, you'd use platform-specific APIs
      return {
        'usage_percent': '0.0',
        'cores': Platform.numberOfProcessors,
      };
    } catch (e) {
      return {
        'usage_percent': '0.0',
        'cores': 1,
        'error': e.toString(),
      };
    }
  }

  // Get device information
  Map<String, dynamic> getDeviceInfo() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
      'number_of_processors': Platform.numberOfProcessors,
      'is_debug': kDebugMode,
    };
  }

  // Check if performance is within acceptable limits
  bool isPerformanceAcceptable(String operationName, int maxTimeMs) {
    final average = getAverageTime(operationName);
    return average <= maxTimeMs;
  }

  // Get performance recommendations
  List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    final metrics = getAllMetrics();
    
    for (final entry in metrics.entries) {
      final name = entry.key;
      final data = entry.value;
      final average = data['average'] as double;
      
      if (average > 1000) {
        recommendations.add('$name is taking ${average.toStringAsFixed(0)}ms on average. Consider optimizing.');
      }
      
      if (data['count'] > 100) {
        recommendations.add('$name has been called ${data['count']} times. Consider caching or reducing calls.');
      }
    }
    
    return recommendations;
  }

  // Monitor app startup time
  void monitorAppStartup() {
    startTimer('app_startup');
  }

  // Record app startup completion
  void recordAppStartupComplete() {
    final duration = stopTimer('app_startup');
    if (kDebugMode) {
      print('App startup took ${duration}ms');
    }
  }

  // Monitor page load time
  void monitorPageLoad(String pageName) {
    startTimer('page_load_$pageName');
  }

  // Record page load completion
  void recordPageLoadComplete(String pageName) {
    final duration = stopTimer('page_load_$pageName');
    if (kDebugMode) {
      print('Page $pageName loaded in ${duration}ms');
    }
  }

  // Monitor database operation time
  void monitorDatabaseOperation(String operation) {
    startTimer('db_$operation');
  }

  // Record database operation completion
  void recordDatabaseOperationComplete(String operation) {
    final duration = stopTimer('db_$operation');
    if (kDebugMode) {
      print('Database operation $operation took ${duration}ms');
    }
  }

  // Monitor network request time
  void monitorNetworkRequest(String endpoint) {
    startTimer('network_$endpoint');
  }

  // Record network request completion
  void recordNetworkRequestComplete(String endpoint) {
    final duration = stopTimer('network_$endpoint');
    if (kDebugMode) {
      print('Network request to $endpoint took ${duration}ms');
    }
  }

  // Monitor file operation time
  void monitorFileOperation(String operation) {
    startTimer('file_$operation');
  }

  // Record file operation completion
  void recordFileOperationComplete(String operation) {
    final duration = stopTimer('file_$operation');
    if (kDebugMode) {
      print('File operation $operation took ${duration}ms');
    }
  }

  // Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final metrics = getAllMetrics();
    final memory = getMemoryUsage();
    final device = getDeviceInfo();
    
    return {
      'metrics': metrics,
      'memory': memory,
      'device': device,
      'recommendations': getPerformanceRecommendations(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Export performance data
  Map<String, dynamic> exportPerformanceData() {
    return {
      'summary': getPerformanceSummary(),
      'raw_measurements': _measurements,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }
}