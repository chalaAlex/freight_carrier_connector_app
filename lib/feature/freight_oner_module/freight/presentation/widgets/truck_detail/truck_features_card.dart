import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

class TruckFeaturesCard extends StatelessWidget {
  final List<String> features;

  const TruckFeaturesCard({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SizeManager.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: SizeManager.s12),
            Wrap(
              spacing: SizeManager.s8,
              runSpacing: SizeManager.s8,
              children: features
                  .map((feature) => _buildFeatureChip(feature))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String feature) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s12,
        vertical: SizeManager.s8,
      ),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SizeManager.r6),
        // ignore: deprecated_member_use
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: AppColors.primary),
          const SizedBox(width: SizeManager.r6),
          Text(
            feature,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
