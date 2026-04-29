import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/truck_detail_entity.dart';

class TruckOwnerCard extends StatelessWidget {
  final TruckOwnerEntity owner;

  const TruckOwnerCard({super.key, required this.owner});

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
              'Owner Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: SizeManager.s16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  // ignore: deprecated_member_use
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    _getInitials(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: SizeManager.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${owner.firstName ?? ''} ${owner.lastName ?? ''}'
                            .trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (owner.phone != null)
                        Text(
                          owner.phone!,
                          style: TextStyle(fontSize: 14, color: AppColors.grey),
                        ),
                      const SizedBox(height: SizeManager.s8),
                      _buildRating(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    final firstName = owner.firstName ?? '';
    final lastName = owner.lastName ?? '';
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0];
    if (lastName.isNotEmpty) initials += lastName[0];
    return initials.toUpperCase();
  }

  Widget _buildRating() {
    final rating = owner.ratingAverage?.toDouble() ?? 0.0;
    final ratingCount = owner.ratingQuantity?.toInt() ?? 0;

    return Row(
      children: [
        Icon(Icons.star, size: 16, color: AppColors.warning),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($ratingCount reviews)',
          style: TextStyle(fontSize: 12, color: AppColors.grey),
        ),
      ],
    );
  }
}
