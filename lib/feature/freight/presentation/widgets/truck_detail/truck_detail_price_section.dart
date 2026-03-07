import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';

class TruckDetailPriceSection extends StatelessWidget {
  final TruckEntity truck;

  const TruckDetailPriceSection({super.key, required this.truck});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${truck.brand ?? ''} ${truck.model ?? ''}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Plate: ${truck.plateNumber ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    truck.pricePerKm?.toStringAsFixed(2) ?? "0.00",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '/km',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
