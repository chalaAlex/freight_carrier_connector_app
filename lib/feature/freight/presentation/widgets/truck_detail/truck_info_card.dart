import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';

class TruckInfoCard extends StatelessWidget {
  final TruckEntity truck;

  const TruckInfoCard({super.key, required this.truck});

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
              'Truck Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: SizeManager.s16),
            _buildInfoRow(
              icon: Icons.attach_money,
              label: 'Price per KM',
              value: '${truck.pricePerKm ?? 0} ETB',
            ),
            const Divider(height: SizeManager.s24),
            _buildInfoRow(
              icon: Icons.scale,
              label: 'Load Capacity',
              value: '${truck.loadCapacity ?? 0} kg',
            ),
            const Divider(height: SizeManager.s24),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Location',
              value: truck.location ?? 'N/A',
            ),
            const Divider(height: SizeManager.s24),
            _buildInfoRow(
              icon: Icons.radar,
              label: 'Service Radius',
              value: '${truck.radiusKm ?? 0} km',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(SizeManager.s8),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(SizeManager.r6),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: SizeManager.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
