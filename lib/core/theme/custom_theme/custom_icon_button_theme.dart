import 'package:flutter/material.dart';

class TIconButtonTheme {
  static IconButtonThemeData lightTextTheme = IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      // ignore: deprecated_member_use
      overlayColor: WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
  );
}
