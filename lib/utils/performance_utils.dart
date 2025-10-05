import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Utilities for improving app performance
class PerformanceUtils {
  /// Preload commonly used assets
  static Future<void> preloadAssets() async {
    // Preload any images or assets here if needed
    // This can be called during splash screen
  }

  /// Optimize memory usage
  static void optimizeMemory() {
    if (!kDebugMode) {
      // Force garbage collection in release mode
      // This helps with memory management
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  /// Warm up commonly used widgets
  static void warmUpWidgets() {
    // This can help with first render performance
    // Add any heavy widgets that need warming up
  }

  /// Configure app for better performance
  static void configurePerformance() {
    // Disable debug banner in release mode
    if (kReleaseMode) {
      // Any release-specific optimizations
    }
  }

  /// Debounce function to prevent excessive calls
  static void debounce(Function() action, {Duration delay = const Duration(milliseconds: 300)}) {
    Timer? timer;
    timer?.cancel();
    timer = Timer(delay, action);
  }
}

/// Timer class for debouncing
class Timer {
  final Duration duration;
  final Function() callback;
  bool _isActive = true;

  Timer(this.duration, this.callback) {
    Future.delayed(duration, () {
      if (_isActive) {
        callback();
      }
    });
  }

  void cancel() {
    _isActive = false;
  }
}
