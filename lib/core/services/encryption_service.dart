import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // Generate a random encryption key
  String generateEncryptionKey({int length = 32}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Simple XOR encryption
  String encrypt(String plaintext, String key) {
    final plaintextBytes = utf8.encode(plaintext);
    final keyBytes = utf8.encode(key);
    final encryptedBytes = <int>[];
    
    for (int i = 0; i < plaintextBytes.length; i++) {
      encryptedBytes.add(plaintextBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64Encode(encryptedBytes);
  }

  // Simple XOR decryption
  String decrypt(String encryptedText, String key) {
    final encryptedBytes = base64Decode(encryptedText);
    final keyBytes = utf8.encode(key);
    final decryptedBytes = <int>[];
    
    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return utf8.decode(decryptedBytes);
  }

  // Hash data with SHA-256
  String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Hash data with SHA-512
  String hashDataSHA512(String data) {
    final bytes = utf8.encode(data);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  // Generate HMAC
  String generateHMAC(String data, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(dataBytes);
    return digest.toString();
  }

  // Verify HMAC
  bool verifyHMAC(String data, String key, String hmac) {
    final expectedHmac = generateHMAC(data, key);
    return expectedHmac == hmac;
  }

  // Encrypt sensitive data
  String encryptSensitiveData(String data, String password) {
    final salt = generateSalt();
    final key = _deriveKey(password, salt);
    final encrypted = encrypt(data, key);
    return '$salt:$encrypted';
  }

  // Decrypt sensitive data
  String decryptSensitiveData(String encryptedData, String password) {
    final parts = encryptedData.split(':');
    if (parts.length != 2) throw Exception('Invalid encrypted data format');
    
    final salt = parts[0];
    final encrypted = parts[1];
    final key = _deriveKey(password, salt);
    return decrypt(encrypted, key);
  }

  // Generate salt
  String generateSalt({int length = 16}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Derive key from password and salt
  String _deriveKey(String password, String salt) {
    final combined = password + salt;
    return hashData(combined);
  }

  // Encrypt file content
  String encryptFileContent(String content, String key) {
    return encrypt(content, key);
  }

  // Decrypt file content
  String decryptFileContent(String encryptedContent, String key) {
    return decrypt(encryptedContent, key);
  }

  // Encrypt JSON data
  String encryptJsonData(Map<String, dynamic> data, String key) {
    final jsonString = jsonEncode(data);
    return encrypt(jsonString, key);
  }

  // Decrypt JSON data
  Map<String, dynamic> decryptJsonData(String encryptedData, String key) {
    final decryptedString = decrypt(encryptedData, key);
    return jsonDecode(decryptedString) as Map<String, dynamic>;
  }

  // Generate secure random string
  String generateSecureString({int length = 32}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Generate secure random number
  int generateSecureNumber({int min = 100000, int max = 999999}) {
    final random = Random.secure();
    return min + random.nextInt(max - min);
  }

  // Encrypt password
  String encryptPassword(String password) {
    final salt = generateSalt();
    final hashedPassword = hashData(password + salt);
    return '$salt:$hashedPassword';
  }

  // Verify password
  bool verifyPassword(String password, String encryptedPassword) {
    final parts = encryptedPassword.split(':');
    if (parts.length != 2) return false;
    
    final salt = parts[0];
    final hashedPassword = parts[1];
    final expectedHash = hashData(password + salt);
    
    return expectedHash == hashedPassword;
  }

  // Encrypt sensitive fields in a map
  Map<String, dynamic> encryptSensitiveFields(
    Map<String, dynamic> data,
    List<String> sensitiveFields,
    String key,
  ) {
    final encryptedData = Map<String, dynamic>.from(data);
    
    for (final field in sensitiveFields) {
      if (encryptedData.containsKey(field) && encryptedData[field] != null) {
        encryptedData[field] = encrypt(encryptedData[field].toString(), key);
      }
    }
    
    return encryptedData;
  }

  // Decrypt sensitive fields in a map
  Map<String, dynamic> decryptSensitiveFields(
    Map<String, dynamic> data,
    List<String> sensitiveFields,
    String key,
  ) {
    final decryptedData = Map<String, dynamic>.from(data);
    
    for (final field in sensitiveFields) {
      if (decryptedData.containsKey(field) && decryptedData[field] != null) {
        try {
          decryptedData[field] = decrypt(decryptedData[field].toString(), key);
        } catch (e) {
          // If decryption fails, keep the original value
        }
      }
    }
    
    return decryptedData;
  }

  // Generate encryption key from password
  String generateKeyFromPassword(String password, String salt) {
    return _deriveKey(password, salt);
  }

  // Check if string is encrypted
  bool isEncrypted(String data) {
    try {
      base64Decode(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get encryption strength
  String getEncryptionStrength(String key) {
    if (key.length >= 32) return 'strong';
    if (key.length >= 16) return 'medium';
    return 'weak';
  }

  // Validate encryption key
  bool isValidEncryptionKey(String key) {
    return key.length >= 8 && key.isNotEmpty;
  }

  // Generate secure token
  String generateSecureToken({int length = 32}) {
    return generateSecureString(length: length);
  }

  // Generate secure session ID
  String generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateSecureString(length: 16);
    return '$timestamp:$random';
  }

  // Validate session ID
  bool isValidSessionId(String sessionId, {int maxAgeMinutes = 60}) {
    try {
      final parts = sessionId.split(':');
      if (parts.length != 2) return false;
      
      final timestamp = int.parse(parts[0]);
      final now = DateTime.now().millisecondsSinceEpoch;
      final ageMinutes = (now - timestamp) / (1000 * 60);
      
      return ageMinutes <= maxAgeMinutes;
    } catch (e) {
      return false;
    }
  }

  // Encrypt database field
  String encryptDatabaseField(String value, String key) {
    return encrypt(value, key);
  }

  // Decrypt database field
  String decryptDatabaseField(String encryptedValue, String key) {
    return decrypt(encryptedValue, key);
  }

  // Generate checksum
  String generateChecksum(String data) {
    return hashData(data);
  }

  // Verify checksum
  bool verifyChecksum(String data, String checksum) {
    return hashData(data) == checksum;
  }

  // Encrypt with timestamp
  String encryptWithTimestamp(String data, String key) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final dataWithTimestamp = '$timestamp:$data';
    return encrypt(dataWithTimestamp, key);
  }

  // Decrypt with timestamp
  String decryptWithTimestamp(String encryptedData, String key, {int maxAgeMinutes = 60}) {
    final decrypted = decrypt(encryptedData, key);
    final parts = decrypted.split(':');
    if (parts.length != 2) throw Exception('Invalid encrypted data format');
    
    final timestamp = int.parse(parts[0]);
    final data = parts[1];
    final now = DateTime.now().millisecondsSinceEpoch;
    final ageMinutes = (now - timestamp) / (1000 * 60);
    
    if (ageMinutes > maxAgeMinutes) {
      throw Exception('Encrypted data has expired');
    }
    
    return data;
  }
}
