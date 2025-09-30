class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'رقم الهاتف غير صحيح';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    
    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    
    if (value.length > 50) {
      return 'الاسم طويل جداً';
    }
    
    return null;
  }

  static String? validateDate(DateTime? value, String fieldName) {
    if (value == null) {
      return '$fieldName مطلوب';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return '$fieldName لا يمكن أن يكون في المستقبل';
    }
    
    return null;
  }

  static String? validateOrdinationDate(DateTime? value) {
    if (value == null) {
      return 'تاريخ الرسامة مطلوب';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return 'تاريخ الرسامة لا يمكن أن يكون في المستقبل';
    }
    
    final minDate = DateTime(1900);
    if (value.isBefore(minDate)) {
      return 'تاريخ الرسامة غير صحيح';
    }
    
    return null;
  }

  static String? validateBirthDate(DateTime? value) {
    if (value == null) {
      return 'تاريخ الميلاد مطلوب';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return 'تاريخ الميلاد لا يمكن أن يكون في المستقبل';
    }
    
    final minDate = DateTime(1900);
    if (value.isBefore(minDate)) {
      return 'تاريخ الميلاد غير صحيح';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    
    return null;
  }
}
