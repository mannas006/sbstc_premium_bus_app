import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color background = Color(0xFF0D0E12); // Sleek Dark Slate
  static const Color surface = Color(0xFF171821); // Dark Card Surface
  
  static const Color primary = Color(0xFFD84E55); // RedBus Crimson Red
  static const Color primaryLight = Color(0xFFFF6B6B); // Soft Red
  
  static const Color secondary = Color(0xFFFF9F43); // Warm Gold/Orange Accent
  static const Color tertiary = Color(0xFF2EC4B6); // Mint Cyan (for status, success)
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF1F2F6);
  static const Color textSecondary = Color(0xFFA0A5B5);
  
  // Effects & Outlines
  static const Color outline = Color(0xFF2D313F);
  
  // Glassmorphism helpers (we will use solid/opaque versions for performance)
  static Color get glassBackground => const Color(0xFF1E202C); 
  static Color get glassBorder => Colors.white.withOpacity(0.08);
  static Color get glassInnerGlow => Colors.white.withOpacity(0.05);
}
