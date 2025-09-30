import 'package:flutter/material.dart';

class ValidationService {
  static final ValidationService _instance = ValidationService._internal();
  factory ValidationService() => _instance;
  ValidationService._internal();

  // Email validation
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    
    return null;
  }

  // Password validation
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    
    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل';
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    
    if (password != confirmPassword) {
      return 'كلمة المرور غير متطابقة';
    }
    
    return null;
  }

  // Name validation
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'الاسم مطلوب';
    }
    
    if (name.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    
    if (name.length > 50) {
      return 'الاسم يجب أن يكون أقل من 50 حرف';
    }
    
    if (!name.contains(RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$'))) {
      return 'الاسم يجب أن يحتوي على أحرف فقط';
    }
    
    return null;
  }

  // Phone number validation
  String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    
    final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'رقم الهاتف غير صحيح';
    }
    
    if (phone.length < 10) {
      return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
    }
    
    return null;
  }

  // Required field validation
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  // Minimum length validation
  String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    
    if (value.length < minLength) {
      return '$fieldName يجب أن يكون $minLength أحرف على الأقل';
    }
    
    return null;
  }

  // Maximum length validation
  String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName يجب أن يكون أقل من $maxLength حرف';
    }
    
    return null;
  }

  // Number validation
  String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName يجب أن يكون رقماً';
    }
    
    return null;
  }

  // Positive number validation
  String? validatePositiveNumber(String? value, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) return numberError;
    
    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName يجب أن يكون أكبر من صفر';
    }
    
    return null;
  }

  // Date validation
  String? validateDate(String? date, String fieldName) {
    if (date == null || date.isEmpty) {
      return '$fieldName مطلوب';
    }
    
    try {
      DateTime.parse(date);
      return null;
    } catch (e) {
      return '$fieldName غير صحيح';
    }
  }

  // Future date validation
  String? validateFutureDate(String? date, String fieldName) {
    final dateError = validateDate(date, fieldName);
    if (dateError != null) return dateError;
    
    final parsedDate = DateTime.parse(date!);
    if (parsedDate.isBefore(DateTime.now())) {
      return '$fieldName يجب أن يكون في المستقبل';
    }
    
    return null;
  }

  // Past date validation
  String? validatePastDate(String? date, String fieldName) {
    final dateError = validateDate(date, fieldName);
    if (dateError != null) return dateError;
    
    final parsedDate = DateTime.parse(date!);
    if (parsedDate.isAfter(DateTime.now())) {
      return '$fieldName يجب أن يكون في الماضي';
    }
    
    return null;
  }

  // URL validation
  String? validateUrl(String? url) {
    if (url == null || url.isEmpty) {
      return 'الرابط مطلوب';
    }
    
    try {
      Uri.parse(url);
      return null;
    } catch (e) {
      return 'الرابط غير صحيح';
    }
  }

  // Bishop name validation
  String? validateBishopName(String? name) {
    return validateName(name);
  }

  // Bishop title validation
  String? validateBishopTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'اللقب مطلوب';
    }
    
    if (title.length < 2) {
      return 'اللقب يجب أن يكون حرفين على الأقل';
    }
    
    if (title.length > 100) {
      return 'اللقب يجب أن يكون أقل من 100 حرف';
    }
    
    return null;
  }

  // Diocese validation
  String? validateDiocese(String? diocese) {
    if (diocese == null || diocese.isEmpty) {
      return 'الأبرشية مطلوبة';
    }
    
    if (diocese.length < 2) {
      return 'الأبرشية يجب أن تكون حرفين على الأقل';
    }
    
    if (diocese.length > 100) {
      return 'الأبرشية يجب أن تكون أقل من 100 حرف';
    }
    
    return null;
  }

  // Biography validation
  String? validateBiography(String? biography) {
    if (biography != null && biography.length > 1000) {
      return 'السيرة الذاتية يجب أن تكون أقل من 1000 حرف';
    }
    
    return null;
  }

  // Address validation
  String? validateAddress(String? address) {
    if (address != null && address.length > 200) {
      return 'العنوان يجب أن يكون أقل من 200 حرف';
    }
    
    return null;
  }

  // Search query validation
  String? validateSearchQuery(String? query) {
    if (query == null || query.isEmpty) {
      return 'نص البحث مطلوب';
    }
    
    if (query.length < 2) {
      return 'نص البحث يجب أن يكون حرفين على الأقل';
    }
    
    return null;
  }

  // Form validation
  String? validateForm(Map<String, String> formData, Map<String, String Function(String?)> validators) {
    for (final entry in validators.entries) {
      final fieldName = entry.key;
      final validator = entry.value;
      final value = formData[fieldName];
      
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    
    return null;
  }

  // Validate all fields in a form
  Map<String, String> validateFormFields(Map<String, String> formData, Map<String, String Function(String?)> validators) {
    final errors = <String, String>{};
    
    for (final entry in validators.entries) {
      final fieldName = entry.key;
      final validator = entry.value;
      final value = formData[fieldName];
      
      final error = validator(value);
      if (error != null) {
        errors[fieldName] = error;
      }
    }
    
    return errors;
  }

  // Check if form is valid
  bool isFormValid(Map<String, String> formData, Map<String, String Function(String?)> validators) {
    for (final entry in validators.entries) {
      final fieldName = entry.key;
      final validator = entry.value;
      final value = formData[fieldName];
      
      final error = validator(value);
      if (error != null) {
        return false;
      }
    }
    
    return true;
  }

  // Get validation error message
  String getValidationErrorMessage(String fieldName, String errorType) {
    switch (errorType) {
      case 'required':
        return '$fieldName مطلوب';
      case 'invalid':
        return '$fieldName غير صحيح';
      case 'too_short':
        return '$fieldName قصير جداً';
      case 'too_long':
        return '$fieldName طويل جداً';
      case 'not_matching':
        return '$fieldName غير متطابق';
      case 'not_found':
        return '$fieldName غير موجود';
      case 'already_exists':
        return '$fieldName موجود بالفعل';
      default:
        return 'خطأ في $fieldName';
    }
  }

  // Validate file size
  String? validateFileSize(int fileSize, int maxSizeInMB) {
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    if (fileSize > maxSizeInBytes) {
      return 'حجم الملف يجب أن يكون أقل من ${maxSizeInMB}MB';
    }
    return null;
  }

  // Validate file type
  String? validateFileType(String fileName, List<String> allowedTypes) {
    final extension = fileName.split('.').last.toLowerCase();
    if (!allowedTypes.contains(extension)) {
      return 'نوع الملف غير مسموح. الأنواع المسموحة: ${allowedTypes.join(', ')}';
    }
    return null;
  }

  // Validate image dimensions
  String? validateImageDimensions(int width, int height, int maxWidth, int maxHeight) {
    if (width > maxWidth || height > maxHeight) {
      return 'أبعاد الصورة يجب أن تكون أقل من ${maxWidth}x${maxHeight}';
    }
    return null;
  }

  // Validate age
  String? validateAge(DateTime birthDate, int minAge, int maxAge) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    
    if (age < minAge) {
      return 'العمر يجب أن يكون $minAge سنة على الأقل';
    }
    
    if (age > maxAge) {
      return 'العمر يجب أن يكون أقل من $maxAge سنة';
    }
    
    return null;
  }

  // Validate bishop age
  String? validateBishopAge(DateTime birthDate) {
    return validateAge(birthDate, 25, 100);
  }

  // Validate ordination date
  String? validateOrdinationDate(DateTime ordinationDate, DateTime birthDate) {
    if (ordinationDate.isBefore(birthDate)) {
      return 'تاريخ الرسامة يجب أن يكون بعد تاريخ الميلاد';
    }
    
    final ageAtOrdination = ordinationDate.year - birthDate.year;
    if (ageAtOrdination < 25) {
      return 'عمر الرسامة يجب أن يكون 25 سنة على الأقل';
    }
    
    return null;
  }
}
