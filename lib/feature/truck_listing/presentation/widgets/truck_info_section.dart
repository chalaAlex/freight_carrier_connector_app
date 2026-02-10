import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import '../../domain/entities/truck.dart';
class TruckInfoSection extends StatelessWidget {
  final TruckDataEntity truck;

  const TruckInfoSection({
    super.key,
    required this.truck,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(truck.model, style: theme.textTheme.headlineSmall),
          const SizedBox(height: SizeManager.s8),

          Text(
            truck.company,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: SizeManager.s16),

          Text(
            'ETB ${truck.pricePerDay.toStringAsFixed(0)} ${StringManager.pricePerDay} • '
            'ETB ${truck.pricePerHour.toStringAsFixed(0)} ${StringManager.pricePerHour}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),

          _buildSpecsRow(theme),
          const SizedBox(height: SizeManager.s16),

          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSpecsRow(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.scale, size: SizeManager.iconSize, color: AppColors.grey),
            const SizedBox(width: SizeManager.s8),
            Text(
              '${truck.capacityTons.toStringAsFixed(1)} ${StringManager.tons}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(width: SizeManager.s24),

            Icon(_getTruckTypeIcon(), size: SizeManager.iconSize, color: AppColors.grey),
            const SizedBox(width: SizeManager.s8),
            Text(_getTruckTypeLabel(), style: theme.textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: SizeManager.s12),
        Row(
          children: [
            const Icon(Icons.location_on, size: SizeManager.iconSize, color: AppColors.grey),
            const SizedBox(width: SizeManager.s8),
            Expanded(
              child: Text(
                '${truck.location} • ${truck.radiusKm.toStringAsFixed(0)}km radius',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: truck.isAvailable ? AppColors.primary : AppColors.lightGrey,
              foregroundColor: truck.isAvailable ? AppColors.white : AppColors.darkGrey,
              minimumSize: const Size(0, SizeManager.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r6),
              ),
            ),
            child: Text(
              truck.isAvailable
                  ? StringManager.requestTruck
                  : StringManager.notifyWhenFree,
            ),
          ),
        ),
        const SizedBox(width: SizeManager.s12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size(0, SizeManager.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r6),
              ),
            ),
            child: const Text(StringManager.viewDetails),
          ),
        ),
      ],
    );
  }

  IconData _getTruckTypeIcon() {
    switch (truck.type) {
      case TruckType.flatbed:
        return Icons.local_shipping;
      case TruckType.refrigerated:
        return Icons.ac_unit;
      case TruckType.dryVan:
        return Icons.inventory_2;
    }
  }

  String _getTruckTypeLabel() {
    switch (truck.type) {
      case TruckType.flatbed:
        return 'Flatbed';
      case TruckType.refrigerated:
        return 'Refrigerated';
      case TruckType.dryVan:
        return 'Dry Van';
    }
  }
}
