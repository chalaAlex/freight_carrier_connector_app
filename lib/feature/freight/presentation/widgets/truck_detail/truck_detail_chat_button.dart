import 'package:clean_architecture/feature/shipment_request/presentation/screen/create_shipment_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck_entity.dart'
    as listing;

class TruckDetailChatButton extends StatelessWidget {
  final TruckEntity? truck;

  const TruckDetailChatButton({super.key, this.truck});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(SizeManager.s16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              if (truck == null) return;
              final listingTruck = listing.TruckEntity(
                id: truck!.id ?? '',
                model: truck!.model ?? '',
                plateNumber: truck!.plateNumber ?? '',
                brand: truck!.brand ?? '',
                pricePerKm: (truck!.pricePerKm ?? 0).toDouble(),
                loadCapacity: (truck!.loadCapacity ?? 0).toDouble(),
                features: truck!.features ?? [],
                location: truck!.location ?? '',
                radiusKm: (truck!.radiusKm ?? 0).toDouble(),
                images: truck!.image ?? [],
                isAvailable: truck!.isAvailable ?? false,
                isVerified: null,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateShipmentRequestScreen(truck: listingTruck),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Send book request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
