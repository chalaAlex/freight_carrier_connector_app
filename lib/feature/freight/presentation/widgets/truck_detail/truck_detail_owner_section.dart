import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';

class TruckDetailOwnerSection extends StatelessWidget {
  final TruckOwnerEntity? owner;

  const TruckDetailOwnerSection({super.key, this.owner});

  @override
  Widget build(BuildContext context) {
    if (owner == null) return const SizedBox.shrink();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About carrier owner',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          // ignore: avoid_unnecessary_containers
          Container(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.carrierUserDetail);
              },
              borderRadius: BorderRadius.circular(SizeManager.r12),
              child: Container(
                padding: const EdgeInsets.all(SizeManager.s12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(SizeManager.r12),
                  border: Border.all(color: colorScheme.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        _getInitials(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: SizeManager.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${owner!.firstName ?? ''} ${owner!.lastName ?? ''}'
                                    .trim(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${owner!.ratingAverage?.toStringAsFixed(1) ?? '0.0'} (${owner!.ratingQuantity ?? 0} reviews)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colorScheme.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials() {
    if (owner == null) return '';
    final firstName = owner!.firstName ?? '';
    final lastName = owner!.lastName ?? '';
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0];
    if (lastName.isNotEmpty) initials += lastName[0];
    return initials.toUpperCase();
  }
}
