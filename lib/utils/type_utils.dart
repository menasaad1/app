class TypeUtils {
  // Safe type conversion utilities
  static String toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
  
  static int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  
  static double toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
  
  static bool toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return false;
  }
  
  static List<T> toList<T>(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      try {
        return value.cast<T>();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
  
  static Map<String, dynamic> toMap(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (e) {
        return {};
      }
    }
    return {};
  }
  
  // Type checking utilities
  static bool isString(dynamic value) => value is String;
  static bool isInt(dynamic value) => value is int;
  static bool isDouble(dynamic value) => value is double;
  static bool isBool(dynamic value) => value is bool;
  static bool isList(dynamic value) => value is List;
  static bool isMap(dynamic value) => value is Map;
  static bool isNull(dynamic value) => value == null;
  static bool isNotNull(dynamic value) => value != null;
  
  // Safe null checking
  static T? safeCast<T>(dynamic value) {
    if (value == null) return null;
    if (value is T) return value;
    return null;
  }
  
  // Safe null coalescing
  static T nullCoalesce<T>(dynamic value, T defaultValue) {
    if (value == null) return defaultValue;
    if (value is T) return value;
    return defaultValue;
  }
  
  // Safe null coalescing with conversion
  static T nullCoalesceWithConversion<T>(dynamic value, T defaultValue, T Function(dynamic) converter) {
    if (value == null) return defaultValue;
    try {
      return converter(value);
    } catch (e) {
      return defaultValue;
    }
  }
}
