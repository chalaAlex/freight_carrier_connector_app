import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class TruckDetailAbout extends StatelessWidget {
  final String aboutText;

  const TruckDetailAbout({super.key, required this.aboutText});

  @override
  Widget build(BuildContext context) {
    if (aboutText.isEmpty) return const SizedBox.shrink();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this truck',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s12),
          Text(
            aboutText,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
