import 'package:flutter/material.dart';

class ColorUtils {
  static const Color primaryColor = Colors.deepPurple;
  static const Color secondaryColor = Colors.purple;
  static const Color accentColor = Colors.deepPurpleAccent;
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color infoColor = Colors.blue;
  
  static Color getPrimaryColorWithOpacity(double opacity) {
    return primaryColor.withValues(alpha: opacity);
  }
  
  static Color getSecondaryColorWithOpacity(double opacity) {
    return secondaryColor.withValues(alpha: opacity);
  }
  
  static Color getAccentColorWithOpacity(double opacity) {
    return accentColor.withValues(alpha: opacity);
  }
  
  static Color getSuccessColorWithOpacity(double opacity) {
    return successColor.withValues(alpha: opacity);
  }
  
  static Color getErrorColorWithOpacity(double opacity) {
    return errorColor.withValues(alpha: opacity);
  }
  
  static Color getWarningColorWithOpacity(double opacity) {
    return warningColor.withValues(alpha: opacity);
  }
  
  static Color getInfoColorWithOpacity(double opacity) {
    return infoColor.withValues(alpha: opacity);
  }
  
  static LinearGradient getPrimaryGradient() {
    return const LinearGradient(
      colors: [primaryColor, secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  static LinearGradient getSuccessGradient() {
    return const LinearGradient(
      colors: [Colors.green, Colors.lightGreen],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  static LinearGradient getErrorGradient() {
    return const LinearGradient(
      colors: [Colors.red, Colors.deepOrange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  static LinearGradient getWarningGradient() {
    return const LinearGradient(
      colors: [Colors.orange, Colors.amber],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  static LinearGradient getInfoGradient() {
    return const LinearGradient(
      colors: [Colors.blue, Colors.lightBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
