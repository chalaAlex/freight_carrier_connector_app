import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import '../../domain/entities/truck_entity.dart';

class TruckInfoSection extends StatelessWidget {
  final TruckEntity truck;

  const TruckInfoSection({super.key, required this.truck});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Padding(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                truck.model,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.textPrimary,
                ),
              ),
              const SizedBox(height: SizeManager.s8),

              Text(
                truck.brand,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.textSecondary,
                ),
              ),
              const SizedBox(height: SizeManager.s16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'ETB ${truck.pricePerKm.toStringAsFixed(0)} ${StringManager.pricePerKm} • ',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),

              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: SizeManager.iconSize,
                    color: colorScheme.textSecondary,
                  ),
                  Text(
                    truck.location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SizeManager.s16),
            ],
          ),
        ],
      ),
    );
  }
}
