import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/theme/custom_theme/custom_input_decoration_theme.dart';
import 'package:clean_architecture/core/theme/custom_theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColorScheme.light.primary,
    scaffoldBackgroundColor: AppColorScheme.light.background,
    textTheme: TTextTheme.lightTextTheme,
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
      primary: AppColorScheme.dark.primary,
      surface: AppColorScheme.dark.surface,
      error: AppColorScheme.dark.error,
    ),
  );
}
