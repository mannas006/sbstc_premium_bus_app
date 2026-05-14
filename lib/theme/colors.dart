import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color background = Color(0xFF121318);
  static const Color surface = Color(0xFF1E1F24); // Slightly lighter than background
  
  static const Color primary = Color(0xFF002366); // Deep Royal Blue
  static const Color primaryLight = Color(0xFF435B9F);
  
  static const Color secondary = Color(0xFFFFD700); // Gold Accents
  static const Color tertiary = Color(0xFF00FFFF); // Soft Cyan
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE3E2E8);
  static const Color textSecondary = Color(0xFFC5C6D2);
  
  // Effects & Outlines
  static const Color outline = Color(0xFF444650);
  
  // Glassmorphism helpers
  static Color get glassBackground => Colors.white.withOpacity(0.08);
  static Color get glassBorder => Colors.white.withOpacity(0.15);
  static Color get glassInnerGlow => Colors.white.withOpacity(0.10);
}
