import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class TruckDetailErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const TruckDetailErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SizeManager.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: SizeManager.s16),
            Text(
              'Error Loading Truck',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: SizeManager.s8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: colorScheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: SizeManager.s24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeManager.s24,
                    vertical: SizeManager.s12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeManager.r12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
