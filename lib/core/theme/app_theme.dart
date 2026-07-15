import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0F1117);
  static const surface = Color(0xFF1A1D27);
  static const surfaceHigh = Color(0xFF222536);
  static const border = Color(0xFF2A2D3E);
  static const accent = Color(0xFF6C63FF);
  static const accentSoft = Color(0x226C63FF);
  static const success = Color(0xFF22C55E);
  static const successSoft = Color(0x2222C55E);
  static const warning = Color(0xFFF59E0B);
  static const warningSoft = Color(0x22F59E0B);
  static const danger = Color(0xFFEF4444);
  static const dangerSoft = Color(0x22EF4444);
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.dark(
      background: AppColors.background,
      surface: AppColors.surface,
      primary: AppColors.accent,
    ),
    dividerColor: AppColors.border,
  );
}
