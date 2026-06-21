import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color background = Color(0xFFF8FAFC); // Modern Light Slate background
  static const Color surface = Color(0xFFFFFFFF); // Pure White Card Surface
  
  static const Color primary = Color(0xFF1D4ED8); // Premium Royal/Indigo Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Vibrant Blue Accent
  
  static const Color secondary = Color(0xFFF59E0B); // Amber Rating / Gold Accent
  static const Color tertiary = Color(0xFF10B981); // Success Emerald Green
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Deep Slate for readability
  static const Color textSecondary = Color(0xFF64748B); // Medium Slate Gray for secondary info
  
  // Effects & Outlines
  static const Color outline = Color(0xFFE2E8F0); // Soft Slate Line Border
  
  // Glassmorphism helpers (updated for premium semi-transparent light theme)
  static Color get glassBackground => const Color(0xE6FFFFFF); 
  static Color get glassBorder => const Color(0x1F000000);
  static Color get glassInnerGlow => const Color(0x0A000000);
}
