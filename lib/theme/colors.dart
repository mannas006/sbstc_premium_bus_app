import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color background = Color(0xFF080C16); // Deep Midnight Navy
  static const Color surface = Color(0xFF101626); // Slate Navy Card Surface
  
  static const Color primary = Color(0xFF2563EB); // SBSTC Royal Blue
  static const Color primaryLight = Color(0xFF38BDF8); // SBSTC Sky Blue
  
  static const Color secondary = Color(0xFFFF9F43); // Warm Gold/Orange Accent (retained for ratings)
  static const Color tertiary = Color(0xFF2EC4B6); // Mint Cyan (for status, success)
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  
  // Effects & Outlines
  static const Color outline = Color(0xFF1E293B);
  
  // Glassmorphism helpers (we will use solid/opaque versions for performance)
  static Color get glassBackground => const Color(0xFF161F33); 
  static Color get glassBorder => Colors.white.withOpacity(0.08);
  static Color get glassInnerGlow => Colors.white.withOpacity(0.05);
}
