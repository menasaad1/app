import 'package:flutter/material.dart';

class ThemeUtils {
  static const Color primaryColor = Colors.deepPurple;
  static const Color secondaryColor = Colors.purple;
  static const Color accentColor = Colors.deepPurpleAccent;
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);
  
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get primaryCardDecoration => BoxDecoration(
    gradient: const LinearGradient(
      colors: [primaryColor, secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x4D9C27B0),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );
  
  static BoxDecoration get infoCardDecoration => BoxDecoration(
    color: const Color(0x0D9C27B0),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0x339C27B0)),
  );
  
  static InputDecoration get inputDecoration => InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
  
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  );
  
  static ButtonStyle get secondaryButtonStyle => TextButton.styleFrom(
    foregroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static TextStyle get titleTextStyle => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    fontFamily: 'Arial',
  );
  
  static TextStyle get subtitleTextStyle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: 'Arial',
  );
  
  static TextStyle get bodyTextStyle => const TextStyle(
    fontSize: 16,
    color: textColor,
    fontFamily: 'Arial',
  );
  
  static TextStyle get captionTextStyle => const TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
    fontFamily: 'Arial',
  );
}
