class StringUtils {
  // Basic string operations
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  static String removeExtraSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  static String removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]'), '');
  }
  
  static String removeNumbers(String text) {
    return text.replaceAll(RegExp(r'\d'), '');
  }
  
  static String removeLetters(String text) {
    return text.replaceAll(RegExp(r'[a-zA-Z]'), '');
  }
  
  static String removeArabicLetters(String text) {
    return text.replaceAll(RegExp(r'[\u0600-\u06FF]'), '');
  }
  
  static String removeEnglishLetters(String text) {
    return text.replaceAll(RegExp(r'[a-zA-Z]'), '');
  }
  
  // Validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }
  
  static bool isValidArabicText(String text) {
    return RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(text);
  }
  
  static bool isValidEnglishText(String text) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
  }
  
  static bool isValidMixedText(String text) {
    return RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(text);
  }
  
  static bool isValidName(String name) {
    return RegExp(r'^[\u0600-\u06FFa-zA-Z\s]{2,50}$').hasMatch(name);
  }
  
  static bool isValidDiocese(String diocese) {
    return RegExp(r'^[\u0600-\u06FFa-zA-Z\s]{2,100}$').hasMatch(diocese);
  }
  
  static bool isValidNotes(String notes) {
    return notes.length <= 500;
  }
  
  // Formatting
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    
    // Format based on length
    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11) {
      return '${digits.substring(0, 1)}-${digits.substring(1, 4)}-${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    
    return phone;
  }
  
  static String formatName(String name) {
    return name.trim().split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  static String formatOrdinationDate(DateTime date) {
    return 'تاريخ الرسامة: ${date.day}/${date.month}/${date.year}';
  }
  
  static String formatBishopName(String name) {
    return 'الأسقف $name';
  }
  
  static String formatDiocese(String diocese) {
    return 'أسقفية $diocese';
  }
  
  static String formatNotes(String notes) {
    if (notes.isEmpty) return 'لا توجد ملاحظات';
    return notes;
  }
  
  // Initials and abbreviations
  static String generateInitials(String name) {
    if (name.isEmpty) return '';
    
    List<String> words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
  }
  
  static String generateAbbreviation(String text) {
    if (text.isEmpty) return '';
    
    List<String> words = text.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    } else {
      return words.map((word) => word.substring(0, 1).toUpperCase()).join('');
    }
  }
  
  // Search and filtering
  static bool containsIgnoreCase(String text, String search) {
    return text.toLowerCase().contains(search.toLowerCase());
  }
  
  static bool startsWithIgnoreCase(String text, String prefix) {
    return text.toLowerCase().startsWith(prefix.toLowerCase());
  }
  
  static bool endsWithIgnoreCase(String text, String suffix) {
    return text.toLowerCase().endsWith(suffix.toLowerCase());
  }
  
  static bool equalsIgnoreCase(String text1, String text2) {
    return text1.toLowerCase() == text2.toLowerCase();
  }
  
  // Arabic text utilities
  static bool isArabicText(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
  
  static bool isEnglishText(String text) {
    return RegExp(r'[a-zA-Z]').hasMatch(text);
  }
  
  static bool isMixedText(String text) {
    return isArabicText(text) && isEnglishText(text);
  }
  
  static String getArabicText(String text) {
    return text.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
  }
  
  static String getEnglishText(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
  }
  
  // Length utilities
  static int getWordCount(String text) {
    if (text.isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
  
  static int getCharacterCount(String text) {
    return text.length;
  }
  
  static int getArabicCharacterCount(String text) {
    return RegExp(r'[\u0600-\u06FF]').allMatches(text).length;
  }
  
  static int getEnglishCharacterCount(String text) {
    return RegExp(r'[a-zA-Z]').allMatches(text).length;
  }
  
  // String cleaning
  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  static String cleanArabicText(String text) {
    return text.trim().replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '').replaceAll(RegExp(r'\s+'), ' ');
  }
  
  static String cleanEnglishText(String text) {
    return text.trim().replaceAll(RegExp(r'[^a-zA-Z\s]'), '').replaceAll(RegExp(r'\s+'), ' ');
  }
}