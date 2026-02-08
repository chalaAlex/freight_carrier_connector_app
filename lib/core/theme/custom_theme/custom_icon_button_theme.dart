import 'package:flutter/material.dart';

class TIconButtonTheme {
  static IconButtonThemeData lightTextTheme = IconButtonThemeData(
    style: ButtonStyle(
      // fixedSize: WidgetStateProperty.all(const Size(40, 40)),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      // foregroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 199, 155, 155)),
      overlayColor: WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),
  );
}
