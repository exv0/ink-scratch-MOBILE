import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors (from your gradient: orange to red)
  static const Color orange = Color(0xFFFF6B35); // Vibrant orange
  static const Color red = Color(0xFFF44336); // Material Red 500
  static const Color orangeAccent = Color(0xFFFF8A65);

  // Text colors
  static const Color textPrimary = Color(
    0xFF1A1A1A,
  ); // Dark gray for light mode
  static const Color textSecondary = Color(0xFF666666); // Medium gray

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF9FAFB); // gray-50 equivalent
  static const Color cardLight = Colors.white;

  // Dark mode colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Borders & dividers
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF333333);

  // Gradient for progress bars
  static const LinearGradient progressGradient = LinearGradient(
    colors: [AppColors.orange, AppColors.red],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
