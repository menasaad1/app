import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String message = 'حدث خطأ غير متوقع';
    
    if (error.toString().contains('network')) {
      message = 'تحقق من اتصال الإنترنت';
    } else if (error.toString().contains('permission')) {
      message = 'ليس لديك صلاحية للقيام بهذا الإجراء';
    } else if (error.toString().contains('not-found')) {
      message = 'البيانات المطلوبة غير موجودة';
    } else if (error.toString().contains('already-exists')) {
      message = 'البيانات موجودة بالفعل';
    } else if (error.toString().contains('invalid-argument')) {
      message = 'البيانات المدخلة غير صحيحة';
    } else if (error.toString().contains('unavailable')) {
      message = 'الخدمة غير متاحة حالياً';
    } else if (error.toString().contains('unauthenticated')) {
      message = 'يرجى تسجيل الدخول مرة أخرى';
    } else if (error.toString().contains('permission-denied')) {
      message = 'ليس لديك صلاحية للوصول';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  static void showNetworkError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تحقق من اتصال الإنترنت',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  static void showPermissionError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'ليس لديك صلاحية للقيام بهذا الإجراء',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
