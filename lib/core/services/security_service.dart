import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  // Generate a secure random string
  String generateSecureToken({int length = 32}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Generate a secure random number
  int generateSecureNumber({int min = 100000, int max = 999999}) {
    final random = Random.secure();
    return min + random.nextInt(max - min);
  }

  // Hash a string using SHA-256
  String hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Hash a string using SHA-512
  String hashStringSHA512(String input) {
    final bytes = utf8.encode(input);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  // Generate a salt for password hashing
  String generateSalt({int length = 16}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Hash a password with salt
  String hashPassword(String password, String salt) {
    final combined = password + salt;
    return hashString(combined);
  }

  // Verify a password against its hash
  bool verifyPassword(String password, String salt, String hash) {
    final hashedPassword = hashPassword(password, salt);
    return hashedPassword == hash;
  }

  // Generate a secure password
  String generateSecurePassword({int length = 12}) {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    const allChars = lowercase + uppercase + numbers + symbols;
    
    final random = Random.secure();
    final password = StringBuffer();
    
    // Ensure at least one character from each category
    password.write(lowercase[random.nextInt(lowercase.length)]);
    password.write(uppercase[random.nextInt(uppercase.length)]);
    password.write(numbers[random.nextInt(numbers.length)]);
    password.write(symbols[random.nextInt(symbols.length)]);
    
    // Fill the rest randomly
    for (int i = 4; i < length; i++) {
      password.write(allChars[random.nextInt(allChars.length)]);
    }
    
    // Shuffle the password
    final passwordList = password.toString().split('');
    passwordList.shuffle(random);
    return passwordList.join('');
  }

  // Check password strength
  PasswordStrength checkPasswordStrength(String password) {
    int score = 0;
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    final hasSymbols = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;
    
    if (hasLowercase) score++;
    if (hasUppercase) score++;
    if (hasNumbers) score++;
    if (hasSymbols) score++;
    if (hasMinLength) score++;
    
    if (score < 2) return PasswordStrength.weak;
    if (score < 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  // Encrypt sensitive data (simple base64 encoding for demo)
  String encryptData(String data) {
    final bytes = utf8.encode(data);
    return base64Encode(bytes);
  }

  // Decrypt sensitive data
  String decryptData(String encryptedData) {
    final bytes = base64Decode(encryptedData);
    return utf8.decode(bytes);
  }

  // Generate a secure session token
  String generateSessionToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateSecureToken(length: 16);
    final combined = '$timestamp:$random';
    return hashString(combined);
  }

  // Validate session token
  bool validateSessionToken(String token, int maxAgeMinutes = 60) {
    try {
      // This is a simplified validation
      // In a real app, you'd store and validate against a database
      return token.length == 64; // SHA-256 hash length
    } catch (e) {
      return false;
    }
  }

  // Sanitize user input
  String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'[<>"\']'), '') // Remove dangerous characters
        .trim();
  }

  // Validate email format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validate phone number format
  bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
    return phoneRegex.hasMatch(phone) && phone.length >= 10;
  }

  // Check if string contains only safe characters
  bool isSafeString(String input) {
    final safeRegex = RegExp(r'^[a-zA-Z0-9\u0600-\u06FF\s\-_.,!?]+$');
    return safeRegex.hasMatch(input);
  }

  // Generate a secure file name
  String generateSecureFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateSecureToken(length: 8);
    final extension = originalName.split('.').last;
    return '${timestamp}_${random}.$extension';
  }

  // Mask sensitive data
  String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) return data;
    
    final visible = data.substring(data.length - visibleChars);
    final masked = '*' * (data.length - visibleChars);
    return masked + visible;
  }

  // Check if data contains sensitive information
  bool containsSensitiveData(String data) {
    final sensitivePatterns = [
      RegExp(r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b'), // Credit card
      RegExp(r'\b\d{3}-\d{2}-\d{4}\b'), // SSN
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'), // Email
      RegExp(r'\b\d{3}-\d{3}-\d{4}\b'), // Phone
    ];
    
    return sensitivePatterns.any((pattern) => pattern.hasMatch(data));
  }

  // Generate a secure API key
  String generateApiKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateSecureToken(length: 24);
    final combined = 'api_${timestamp}_$random';
    return hashString(combined);
  }

  // Validate API key format
  bool isValidApiKey(String apiKey) {
    return apiKey.length >= 32 && apiKey.contains(RegExp(r'^[a-f0-9]+$'));
  }

  // Generate a secure nonce
  String generateNonce() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateSecureToken(length: 16);
    return '$timestamp:$random';
  }

  // Validate nonce
  bool validateNonce(String nonce, int maxAgeMinutes = 5) {
    try {
      final parts = nonce.split(':');
      if (parts.length != 2) return false;
      
      final timestamp = int.parse(parts[0]);
      final now = DateTime.now().millisecondsSinceEpoch;
      final ageMinutes = (now - timestamp) / (1000 * 60);
      
      return ageMinutes <= maxAgeMinutes;
    } catch (e) {
      return false;
    }
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong,
}