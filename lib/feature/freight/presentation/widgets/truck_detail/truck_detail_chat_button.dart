import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';

class TruckDetailChatButton extends StatelessWidget {
  final TruckOwnerEntity? owner;

  const TruckDetailChatButton({super.key, this.owner});

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
              _showChatDialog(context, colorScheme);
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Chat with Driver'),
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

  void _showChatDialog(BuildContext context, AppColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(SizeManager.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: SizeManager.s24),
            Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.primary),
            const SizedBox(height: SizeManager.s16),
            Text(
              'Contact Driver',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: SizeManager.s8),
            Text(
              'Chat feature coming soon! You\'ll be able to message ${owner?.firstName ?? 'the driver'} directly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: colorScheme.textSecondary),
            ),
            const SizedBox(height: SizeManager.s24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement call functionality
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(
                        vertical: SizeManager.s12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeManager.r12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: SizeManager.s12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement message functionality
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: SizeManager.s12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeManager.r12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
