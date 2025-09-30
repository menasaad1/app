import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Safe data extraction
  static Map<String, dynamic> extractDocumentData(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data();
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
  
  // Safe data extraction for DocumentSnapshot
  static Map<String, dynamic> extractDocumentSnapshotData(DocumentSnapshot doc) {
    try {
      final data = doc.data();
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
  
  // Safe user data extraction
  static Map<String, dynamic> extractUserData(dynamic user) {
    if (user == null) return {};
    
    try {
      return {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'isAnonymous': user.isAnonymous,
        'metadata': {
          'creationTime': user.metadata.creationTime?.toIso8601String(),
          'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
        },
      };
    } catch (e) {
      return {};
    }
  }
  
  // Safe timestamp conversion
  static DateTime? safeTimestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    
    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is DateTime) {
        return timestamp;
      } else if (timestamp is String) {
        return DateTime.parse(timestamp);
      }
    } catch (e) {
      return null;
    }
    
    return null;
  }
  
  // Safe string conversion
  static String safeString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
  
  // Safe int conversion
  static int safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  
  // Safe double conversion
  static double safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
  
  // Safe bool conversion
  static bool safeBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return false;
  }
  
  // Safe list conversion
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
  
  // Safe map conversion
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
}
