import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

/// Widget that displays a truck image with an availability badge overlay.
///
/// The image is displayed with rounded corners and a badge positioned at the
/// top-right corner showing either "Available" (green) or "Busy" (red).
class TruckImageSection extends StatelessWidget {
  final String imageUrl;
  final bool isAvailable;

  const TruckImageSection({
    super.key,
    required this.imageUrl,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeManager.cardRadius),
      child: Stack(
        children: [
          // Truck image with placeholder for loading/error
          Image.network(
            imageUrl,
            height: SizeManager.imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: SizeManager.imageHeight,
                width: double.infinity,
                color: colorScheme.border,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: SizeManager.imageHeight,
                width: double.infinity,
                color: colorScheme.border,
                child: Icon(
                  Icons.local_shipping,
                  size: 64,
                  color: colorScheme.textSecondary,
                ),
              );
            },
          ),
          // Availability badge positioned at top-right corner
          Positioned(
            top: SizeManager.s12,
            right: SizeManager.s12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SizeManager.badgePadding,
                vertical: SizeManager.s8,
              ),
              decoration: BoxDecoration(
                color: isAvailable ? AppColors.success : AppColors.error,
                borderRadius: BorderRadius.circular(SizeManager.badgeRadius),
              ),
              child: Text(
                isAvailable ? StringManager.available : StringManager.busy,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
