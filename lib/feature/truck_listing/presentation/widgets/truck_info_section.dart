import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import '../../domain/entities/truck.dart';

/// Widget that displays detailed truck information including model, company,
/// pricing, specifications, and action buttons.
///
/// The section shows:
/// - Truck model name (headline style)
/// - Company name (subtitle style)
/// - Pricing information (per day and per hour)
/// - Specifications with icons (capacity, type, location)
/// - Action buttons based on availability status
class TruckInfoSection extends StatelessWidget {
  final Truck truck;

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
          // Truck model name
          Text(
            truck.model,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: SizeManager.s8),

          // Company name
          Text(
            truck.company,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: SizeManager.s16),

          // Pricing row
          Text(
            'ETB ${truck.pricePerDay.toStringAsFixed(0)} ${StringManager.pricePerDay} • ETB ${truck.pricePerHour.toStringAsFixed(0)} ${StringManager.pricePerHour}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),

          // Specs row with icons
          _buildSpecsRow(theme),
          const SizedBox(height: SizeManager.s16),

          // Action buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  /// Builds the specifications row with icons for capacity, type, and location
  Widget _buildSpecsRow(ThemeData theme) {
    return Column(
      children: [
        // Capacity and Type
        Row(
          children: [
            // Capacity
            Icon(
              Icons.scale,
              size: SizeManager.iconSize,
              color: AppColors.grey,
            ),
            const SizedBox(width: SizeManager.s8),
            Text(
              '${truck.capacityTons.toStringAsFixed(1)} ${StringManager.tons}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(width: SizeManager.s24),

            // Type
            Icon(
              _getTruckTypeIcon(),
              size: SizeManager.iconSize,
              color: AppColors.grey,
            ),
            const SizedBox(width: SizeManager.s8),
            Text(
              _getTruckTypeLabel(),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: SizeManager.s12),

        // Location
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: SizeManager.iconSize,
              color: AppColors.grey,
            ),
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

  /// Builds action buttons based on truck availability
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Primary action button (Request Truck or Notify When Free)
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: truck.isAvailable
                  ? AppColors.primary
                  : AppColors.lightGrey,
              foregroundColor: truck.isAvailable
                  ? AppColors.white
                  : AppColors.darkGrey,
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

        // View Details button (always secondary)
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: Implement action
            },
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

  /// Returns the appropriate icon for the truck type
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

  /// Returns the human-readable label for the truck type
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
