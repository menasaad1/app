class CollectionUtils {
  // Safe list operations
  static List<T> safeList<T>(dynamic value) {
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
  
  // Safe map operations
  static Map<String, dynamic> safeMap(dynamic value) {
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
  
  // Safe list access
  static T? safeGet<T>(List<T> list, int index) {
    if (list.isEmpty || index < 0 || index >= list.length) return null;
    return list[index];
  }
  
  // Safe map access
  static T? safeGet<T>(Map<String, dynamic> map, String key) {
    if (map.isEmpty || !map.containsKey(key)) return null;
    final value = map[key];
    if (value is T) return value;
    return null;
  }
  
  // Safe list addition
  static List<T> safeAdd<T>(List<T> list, T item) {
    if (list == null) return [item];
    return [...list, item];
  }
  
  // Safe map addition
  static Map<String, dynamic> safeAdd(Map<String, dynamic> map, String key, dynamic value) {
    if (map == null) return {key: value};
    return {...map, key: value};
  }
  
  // Safe list removal
  static List<T> safeRemove<T>(List<T> list, T item) {
    if (list == null) return [];
    return list.where((element) => element != item).toList();
  }
  
  // Safe map removal
  static Map<String, dynamic> safeRemove(Map<String, dynamic> map, String key) {
    if (map == null) return {};
    final newMap = Map<String, dynamic>.from(map);
    newMap.remove(key);
    return newMap;
  }
  
  // Safe list update
  static List<T> safeUpdate<T>(List<T> list, int index, T item) {
    if (list == null || index < 0 || index >= list.length) return list ?? [];
    final newList = List<T>.from(list);
    newList[index] = item;
    return newList;
  }
  
  // Safe map update
  static Map<String, dynamic> safeUpdate(Map<String, dynamic> map, String key, dynamic value) {
    if (map == null) return {key: value};
    return {...map, key: value};
  }
  
  // Safe list filtering
  static List<T> safeFilter<T>(List<T> list, bool Function(T) predicate) {
    if (list == null) return [];
    try {
      return list.where(predicate).toList();
    } catch (e) {
      return [];
    }
  }
  
  // Safe list mapping
  static List<R> safeMap<T, R>(List<T> list, R Function(T) mapper) {
    if (list == null) return [];
    try {
      return list.map(mapper).toList();
    } catch (e) {
      return [];
    }
  }
  
  // Safe list reduction
  static T safeReduce<T>(List<T> list, T Function(T, T) reducer, T initialValue) {
    if (list == null || list.isEmpty) return initialValue;
    try {
      return list.reduce(reducer);
    } catch (e) {
      return initialValue;
    }
  }
}
