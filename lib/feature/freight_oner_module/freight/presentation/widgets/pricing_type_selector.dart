import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class PricingTypeSelector extends StatelessWidget {
  final AppColorScheme colorScheme;
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const PricingTypeSelector({
    super.key,
    required this.colorScheme,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PricingTypeButton(
            colorScheme: colorScheme,
            type: 'Fixed',
            isSelected: selectedType == 'Fixed',
            onTap: () => onTypeSelected('Fixed'),
          ),
        ),
        const SizedBox(width: SizeManager.s12),
        Expanded(
          child: _PricingTypeButton(
            colorScheme: colorScheme,
            type: 'Negotiable',
            isSelected: selectedType == 'Negotiable',
            onTap: () => onTypeSelected('Negotiable'),
          ),
        ),
      ],
    );
  }
}

class _PricingTypeButton extends StatelessWidget {
  final AppColorScheme colorScheme;
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const _PricingTypeButton({
    required this.colorScheme,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SizeManager.s12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : colorScheme.background,
          borderRadius: BorderRadius.circular(SizeManager.r6),
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? AppColors.white : colorScheme.textPrimary,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
