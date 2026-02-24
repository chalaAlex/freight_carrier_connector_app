import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import '../../domain/entities/truck.dart';
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
    return Card(
      elevation: SizeManager.cardElevation,
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
