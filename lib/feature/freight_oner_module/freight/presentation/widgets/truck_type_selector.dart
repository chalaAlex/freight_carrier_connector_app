import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class TruckTypeSelector extends StatelessWidget {
  final AppColorScheme colorScheme;
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const TruckTypeSelector({
    super.key,
    required this.colorScheme,
    required this.selectedType,
    required this.onTypeSelected,
  });

  static const List<Map<String, dynamic>> truckTypes = [
    {'label': 'Box', 'value': 'BOX', 'icon': Icons.local_shipping},
    {'label': 'Flatbed', 'value': 'FLATBED', 'icon': Icons.agriculture},
    {'label': 'Refrigerated', 'value': 'REFRIGERATED', 'icon': Icons.ac_unit},
    {'label': 'Tanker', 'value': 'TANKER', 'icon': Icons.water_drop},
    {'label': 'Lowbed', 'value': 'LOWBED', 'icon': Icons.construction},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SizeManager.s8,
      runSpacing: SizeManager.s8,
      children: truckTypes.map((type) {
        return _TruckTypeChip(
          colorScheme: colorScheme,
          label: type['label'] as String,
          value: type['value'] as String,
          icon: type['icon'] as IconData,
          isSelected: selectedType == type['value'],
          onTap: () => onTypeSelected(type['value'] as String),
        );
      }).toList(),
    );
  }
}

class _TruckTypeChip extends StatelessWidget {
  final AppColorScheme colorScheme;
  final String label;
  final String value;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TruckTypeChip({
    required this.colorScheme,
    required this.label,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s12,
          vertical: SizeManager.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : colorScheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.white : colorScheme.textPrimary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : colorScheme.textPrimary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
