import 'package:flutter/material.dart';

/// Utilities for handling Arabic fonts and text rendering
class FontUtils {
  /// Default Arabic font family - using system fonts for better compatibility
  static const String defaultArabicFont = 'Arial';
  
  /// Get optimized text style for Arabic text
  static TextStyle getArabicTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: defaultArabicFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? Colors.black87,
      height: height ?? 1.4, // Better line height for Arabic
      textBaseline: TextBaseline.alphabetic,
    );
  }

  /// Get heading style for Arabic text
  static TextStyle getArabicHeadingStyle({
    double fontSize = 20,
    Color? color,
  }) {
    return getArabicTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      height: 1.3,
    );
  }

  /// Get body style for Arabic text
  static TextStyle getArabicBodyStyle({
    double fontSize = 14,
    Color? color,
  }) {
    return getArabicTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.5,
    );
  }

  /// Get caption style for Arabic text
  static TextStyle getArabicCaptionStyle({
    double fontSize = 12,
    Color? color,
  }) {
    return getArabicTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.grey[600],
      height: 1.4,
    );
  }

  /// Check if text contains Arabic characters
  static bool containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  /// Get text direction based on content
  static TextDirection getTextDirection(String text) {
    return containsArabic(text) ? TextDirection.rtl : TextDirection.ltr;
  }
}
