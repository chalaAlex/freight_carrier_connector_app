import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/theme/custom_theme/custom_icon_button_theme.dart';
import 'package:clean_architecture/core/theme/custom_theme/custom_input_decoration_theme.dart';
import 'package:clean_architecture/core/theme/custom_theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColorScheme.light.primary,
    scaffoldBackgroundColor: AppColorScheme.light.background,
    textTheme: TTextTheme.lightTextTheme,

    // --------------- INPUT DECORATION THEME ---------------
    inputDecorationTheme: TInputTheme.lightInputTheme(
      AppColorScheme.light.surface,
      AppColorScheme.light.primary,
      AppColorScheme.light.textSecondary,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColorScheme.light.primary,
      surface: AppColorScheme.light.surface,
      error: AppColorScheme.light.error,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // -------- INPUT DECORATION DARK THEME -------
    inputDecorationTheme: TInputTheme.darkInputTheme(
      AppColorScheme.dark.surface,
      AppColorScheme.dark.primary,
      AppColorScheme.dark.textSecondary,
    ),
    textTheme: TTextTheme.darkTextTheme,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColorScheme.dark.primary,
      surface: AppColorScheme.dark.surface,
      error: AppColorScheme.dark.error,
    ),
  );
}
