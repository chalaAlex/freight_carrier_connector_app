import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class TruckDetailFeatures extends StatelessWidget {
  final List<String> features;

  const TruckDetailFeatures({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) return const SizedBox.shrink();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features & Docs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          Wrap(
            spacing: SizeManager.s12,
            runSpacing: SizeManager.s12,
            children: features
                .map((feature) => _buildFeatureChip(feature, colorScheme))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String feature, AppColorScheme colorScheme) {
    final IconData icon = _getFeatureIcon(feature);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s12,
        vertical: SizeManager.s8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        border: Border.all(color: colorScheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: SizeManager.s8),
          Text(
            feature,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFeatureIcon(String feature) {
    final lowerFeature = feature.toLowerCase();

    if (lowerFeature.contains('insur')) return Icons.shield;
    if (lowerFeature.contains('gps') || lowerFeature.contains('track')) {
      return Icons.gps_fixed;
    }
    if (lowerFeature.contains('refrig') || lowerFeature.contains('cool')) {
      return Icons.ac_unit;
    }
    if (lowerFeature.contains('flatbed')) return Icons.view_agenda;

    return Icons.check_circle;
  }
}
