import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

/// A widget that displays an empty state when no trucks are available.
///
/// Shows an icon/illustration with a message and suggestion text,
/// centered vertically and horizontally.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

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
            // Empty state icon
            Icon(
              Icons.local_shipping_outlined,
              size: 80,
              color: colorScheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: SizeManager.s24),

            // No trucks available message
            Text(
              StringManager.noTrucksAvailable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SizeManager.s12),

            // Suggestion text
            Text(
              StringManager.checkBackLater,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
