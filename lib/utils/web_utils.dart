import 'dart:math' as math;

/// Utilities for handling Flutter Web specific issues
class WebUtils {
  /// Clamps a double value to avoid precision issues in Flutter Web
  static double safeClamp(double value, double min, double max) {
    if (value.isNaN || value.isInfinite) {
      return min;
    }
    
    // Round to avoid floating point precision issues
    final roundedValue = (value * 100).round() / 100;
    return math.max(min, math.min(max, roundedValue));
  }
  
  /// Safely converts a double to avoid precision issues
  static double safeDouble(double value) {
    if (value.isNaN || value.isInfinite) {
      return 0.0;
    }
    
    // Round to 2 decimal places to avoid precision issues
    return (value * 100).round() / 100;
  }
  
  /// Creates a safe size value for widgets
  static double safeSize(double value, {double defaultValue = 0.0}) {
    if (value.isNaN || value.isInfinite || value < 0) {
      return defaultValue;
    }
    
    // Ensure minimum size and round to avoid precision issues
    final roundedValue = (value * 100).round() / 100;
    return math.max(0.0, roundedValue);
  }
  
  /// Creates safe padding/margin values
  static double safePadding(double value) {
    return safeSize(value, defaultValue: 8.0);
  }
  
  /// Creates safe font size
  static double safeFontSize(double value) {
    return safeSize(value, defaultValue: 14.0);
  }
}

/// Extension to add safe methods to double
extension SafeDouble on double {
  /// Returns a safe double value without precision issues
  double get safe => WebUtils.safeDouble(this);
  
  /// Returns a safe size value
  double get safeSize => WebUtils.safeSize(this);
  
  /// Returns a safe padding value
  double get safePadding => WebUtils.safePadding(this);
  
  /// Returns a safe font size
  double get safeFontSize => WebUtils.safeFontSize(this);
}
