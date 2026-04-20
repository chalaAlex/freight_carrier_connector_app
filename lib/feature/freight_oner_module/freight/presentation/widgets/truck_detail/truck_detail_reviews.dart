import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/truck_detail_entity.dart';

class TruckDetailReviews extends StatelessWidget {
  final TruckOwnerEntity? owner;

  const TruckDetailReviews({super.key, this.owner});

  @override
  Widget build(BuildContext context) {
    if (owner == null) return const SizedBox.shrink();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all reviews
                },
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s12),
          _buildReviewCard(colorScheme),
        ],
      ),
    );
  }

  Widget _buildReviewCard(AppColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        border: Border.all(color: colorScheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(Icons.star, size: 16, color: AppColors.warning),
              ),
              const SizedBox(width: SizeManager.s8),
              Text(
                'Excellent Service',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s12),
          Text(
            'John was fantastic! He arrived early for pickup and the goods were delivered in perfect condition. Professional service all the way.',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: SizeManager.s12),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: colorScheme.border,
                child: Text(
                  'M',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: SizeManager.s8),
              Text(
                'Mike R.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: colorScheme.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '2 days ago',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
