import 'package:flutter/material.dart';

class TAppDecorationsTheme {
  static const BorderRadius borderRadiusNone = BorderRadius.zero;
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(4),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(8),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(12),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(999),
  );

  static List<BoxShadow> shadowSm = [
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  static BoxBorder borderLight = Border.all(width: 1);

  static BoxBorder borderDark = Border.all(width: 1);
}
