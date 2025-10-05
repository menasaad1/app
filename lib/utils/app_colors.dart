import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6B46C1);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color primaryRed = Color(0xFFEF4444);
  static const Color primaryOrange = Color(0xFFF59E0B);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Status Colors
  static const Color statusActive = Color(0xFF10B981);
  static const Color statusInactive = Color(0xFFEF4444);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusInfo = Color(0xFF3B82F6);

  // Gradient Colors
  static const List<Color> purpleGradient = [
    Color(0xFFA78BFA),
    Color(0xFF8B5CF6),
    Color(0xFF7C3AED),
  ];

  static const List<Color> blueGradient = [
    Color(0xFF60A5FA),
    Color(0xFF3B82F6),
    Color(0xFF2563EB),
  ];

  static const List<Color> greenGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
    Color(0xFF047857),
  ];

  static const List<Color> redGradient = [
    Color(0xFFEF4444),
    Color(0xFFDC2626),
    Color(0xFFB91C1C),
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color borderDark = Color(0xFF94A3B8);

  // Card Colors for different types
  static const Color cardBishop = Color(0xFF8B5CF6);
  static const Color cardPriest = Color(0xFF3B82F6);
  static const Color cardAdmin = Color(0xFF6B46C1);

  // Helper methods
  static Color getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'bishop':
        return cardBishop;
      case 'priest':
        return cardPriest;
      case 'admin':
        return cardAdmin;
      default:
        return primaryPurple;
    }
  }

  static List<Color> getCardGradient(String type) {
    switch (type.toLowerCase()) {
      case 'bishop':
        return purpleGradient;
      case 'priest':
        return blueGradient;
      case 'admin':
        return purpleGradient;
      default:
        return purpleGradient;
    }
  }

  static Color getStatusColor(bool isActive) {
    return isActive ? statusActive : statusInactive;
  }

  static List<Color> getStatusGradient(bool isActive) {
    return isActive ? greenGradient : redGradient;
  }
}
