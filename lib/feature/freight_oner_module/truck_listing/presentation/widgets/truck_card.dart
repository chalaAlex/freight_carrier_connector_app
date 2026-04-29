import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import '../../domain/entities/truck_entity.dart';
import 'truck_image_section.dart';
import 'truck_info_section.dart';

class TruckCard extends StatelessWidget {
  final TruckEntity truck;
  final VoidCallback? onTap;
  final int index;

  const TruckCard({
    super.key,
    required this.truck,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Card(
      elevation: SizeManager.cardElevation,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeManager.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SizeManager.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TruckImageSection(
              imageUrl: truck.images.isNotEmpty ? truck.images[0] : '',
              isAvailable: truck.isAvailable,
            ),
            TruckInfoSection(truck: truck),
          ],
        ),
      ),
    );
  }
}
