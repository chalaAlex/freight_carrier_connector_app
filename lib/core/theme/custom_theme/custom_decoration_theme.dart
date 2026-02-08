import 'package:flutter/material.dart';

class TAppDecorationsTheme {
  // Border Radius
  static const BorderRadius borderRadiusNone = BorderRadius.zero;
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(4));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(12));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(16));
  static const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(999));
  
  // Shadows
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Borders
  static BoxBorder borderLight = Border.all(
    // color: AppColors.gray200,
    width: 1,
  );
  
  static BoxBorder borderDark = Border.all(
    // color: AppColors.gray700,
    width: 1,
  );
}