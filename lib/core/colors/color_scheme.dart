import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppColorScheme {
  final Color background;
  final Color surface;
  final Color primary;
  final Color onPrimary;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color error;
  final Color success;

  const AppColorScheme({
    required this.background,
    required this.surface,
    required this.primary,
    required this.onPrimary,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.error,
    required this.success,
  });

  static const light = AppColorScheme(
    background: AppColors.white,
    surface: AppColors.lightGrey,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    textPrimary: AppColors.black,
    textSecondary: AppColors.grey,
    border: Color(0xFFE5E7EB),
    error: AppColors.error,
    success: AppColors.success,
  );

  static const dark = AppColorScheme(
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    textPrimary: AppColors.white,
    textSecondary: Color(0xFFB3B3B3),
    border: Color(0xFF2C2C2C),
    error: AppColors.error,
    success: AppColors.success,
  );
}
