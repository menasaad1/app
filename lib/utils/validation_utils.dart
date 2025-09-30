class ValidationUtils {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال اسم الأسقف';
    }
    if (value.trim().length < 2) {
      return 'اسم الأسقف يجب أن يكون حرفين على الأقل';
    }
    if (value.trim().length > 100) {
      return 'اسم الأسقف يجب أن يكون أقل من 100 حرف';
    }
    return null;
  }
  
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!value.contains('@')) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }
  
  static String? validateDiocese(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length > 100) {
        return 'اسم الأسقفية يجب أن يكون أقل من 100 حرف';
      }
    }
    return null;
  }
  
  static String? validateNotes(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length > 500) {
        return 'الملاحظات يجب أن تكون أقل من 500 حرف';
      }
    }
    return null;
  }
  
  static String? validateOrdinationDate(DateTime? date) {
    if (date == null) {
      return 'يرجى اختيار تاريخ الرسامة';
    }
    
    final now = DateTime.now();
    final minDate = DateTime(1900);
    
    if (date.isBefore(minDate)) {
      return 'تاريخ الرسامة يجب أن يكون بعد عام 1900';
    }
    
    if (date.isAfter(now)) {
      return 'تاريخ الرسامة لا يمكن أن يكون في المستقبل';
    }
    
    return null;
  }
}