import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

/// A widget that displays an error message with a retry button.
///
/// Used to show error states with the ability for users to retry the failed operation.
/// Centers content vertically and horizontally with appropriate spacing.
class ErrorRetryWidget extends StatelessWidget {
  /// The error message to display
  final String message;

  /// Callback function invoked when the retry button is tapped
  final VoidCallback onRetry;

  const ErrorRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error icon
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: SizeManager.s24),

            // Error message
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colorScheme.textSecondary),
            ),
            const SizedBox(height: SizeManager.s32),

            // Retry button
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s32,
                  vertical: SizeManager.s12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeManager.r12),
                ),
              ),
              child: const Text(StringManager.retry),
            ),
          ],
        ),
      ),
    );
  }
}
