import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:flutter/material.dart';

extension ThemeGetter on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;
  AppColorScheme get appColors => Theme.of(this).brightness == Brightness.dark
      ? AppColorScheme.dark
      : AppColorScheme.light;
}
