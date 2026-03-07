import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';

class TruckDetailSpecifications extends StatelessWidget {
  final TruckEntity truck;

  const TruckDetailSpecifications({super.key, required this.truck});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          Row(
            children: [
              Expanded(
                child: _buildSpecCard(
                  icon: Icons.scale,
                  label: 'LOAD CAPACITY',
                  value: '${_formatNumber(truck.loadCapacity)} lbs',
                  color: AppColors.primary,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: SizeManager.s12),
              Expanded(
                child: _buildSpecCard(
                  icon: Icons.local_shipping,
                  label: 'TYPE',
                  value: _getTruckType(truck.features),
                  color: AppColors.primary,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required AppColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        // border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: SizeManager.s12),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorScheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(num? number) {
    if (number == null) return '0';
    return number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _getTruckType(List<String>? features) {
    if (features == null || features.isEmpty) return 'Standard';

    // Check for specific truck types in features
    for (var feature in features) {
      final lowerFeature = feature.toLowerCase();
      if (lowerFeature.contains('dry') || lowerFeature.contains('van')) {
        return 'Dry Van';
      }
      if (lowerFeature.contains('refrigerat') ||
          lowerFeature.contains('reefer')) {
        return 'Refrigerated';
      }
      if (lowerFeature.contains('flatbed')) {
        return 'Flatbed';
      }
    }

    return 'Standard';
  }
}
