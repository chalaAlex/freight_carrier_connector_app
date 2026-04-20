import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

enum DropdownState { initial, loading, loaded, error, empty }

class StatefulFreightDropdown extends StatelessWidget {
  final AppColorScheme colorScheme;
  final String? value;
  final String label;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final DropdownState state;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const StatefulFreightDropdown({
    super.key,
    required this.colorScheme,
    required this.value,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.state = DropdownState.loaded,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SizeManager.s8),
        _buildDropdownContent(),
      ],
    );
  }

  Widget _buildDropdownContent() {
    switch (state) {
      case DropdownState.loading:
        return _buildLoadingState();
      case DropdownState.error:
        return _buildErrorState();
      case DropdownState.empty:
        return _buildEmptyState();
      case DropdownState.initial:
      case DropdownState.loaded:
        return _buildDropdown();
    }
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: value,
      hint: Text(hint, style: TextStyle(color: colorScheme.textSecondary)),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: items.isEmpty ? null : onChanged,
      style: TextStyle(color: colorScheme.textPrimary),
      dropdownColor: colorScheme.surface,
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r6),
          borderSide: BorderSide(color: colorScheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r6),
          borderSide: BorderSide(color: colorScheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r6),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeManager.r6),
          borderSide: BorderSide(
            color: colorScheme.border.withValues(alpha: 0.5),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s12,
          vertical: SizeManager.s12,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s12,
        vertical: SizeManager.s12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r6),
        border: Border.all(color: colorScheme.border),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: SizeManager.s12),
          Text(
            'Loading...',
            style: TextStyle(color: colorScheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(SizeManager.r6),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: SizeManager.s8),
          Expanded(
            child: Text(
              errorMessage ?? 'Failed to load data',
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: SizeManager.s8),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r6),
        border: Border.all(color: colorScheme.border),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.textSecondary, size: 20),
          const SizedBox(width: SizeManager.s8),
          Expanded(
            child: Text(
              'No items available',
              style: TextStyle(color: colorScheme.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
