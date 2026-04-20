import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/theme/custom_theme/custom_input_decoration_theme.dart';
import 'package:clean_architecture/core/theme/custom_theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.darkGrey,
    scaffoldBackgroundColor: AppColorScheme.light.background,
    textTheme: TTextTheme.lightTextTheme,
    inputDecorationTheme: TInputTheme.lightInputTheme(
      AppColorScheme.light.surface,
      AppColorScheme.light.primary,
      AppColorScheme.light.textSecondary,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.darkGrey,
      onPrimary: AppColors.white,
      secondary: AppColors.white,
      onSecondary: AppColors.darkGrey,
      surface: AppColorScheme.light.surface,
      error: AppColorScheme.light.error,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGrey,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.35),
        disabledForegroundColor: AppColors.white.withValues(alpha: 0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    inputDecorationTheme: TInputTheme.darkInputTheme(
      AppColorScheme.dark.surface,
      AppColorScheme.dark.primary,
      AppColorScheme.dark.textSecondary,
    ),
    textTheme: TTextTheme.darkTextTheme,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.darkGrey,
      onPrimary: AppColors.white,
      secondary: AppColors.white,
      onSecondary: AppColors.darkGrey,
      surface: AppColorScheme.dark.surface,
      error: AppColorScheme.dark.error,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGrey,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.35),
        disabledForegroundColor: AppColors.white.withValues(alpha: 0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
