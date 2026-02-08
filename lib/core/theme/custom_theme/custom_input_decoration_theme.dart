import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:flutter/material.dart';

class TInputTheme {
  static InputDecorationTheme lightInputTheme(
    Color surface,
    Color primary,
    Color textSecondary,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: surface,
      labelStyle: TextStyle(color: textSecondary),
      hintStyle: TextStyle(color: textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        borderSide: BorderSide(color: surface),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        borderSide: BorderSide(color: surface),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s16,
        vertical: SizeManager.s16,
      ),
    );
  }

  static InputDecorationTheme darkInputTheme(
    Color surface,
    Color primary,
    Color textSecondary,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: surface,
      labelStyle: TextStyle(color: textSecondary),
      hintStyle: TextStyle(color: textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        borderSide: BorderSide(color: surface),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        borderSide: BorderSide(color: surface),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s16,
        vertical: SizeManager.s16,
      ),
    );
  }
}
