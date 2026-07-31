import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class TruckTypeSelector extends StatelessWidget {
  final AppColorScheme colorScheme;
  final List<String> selectedTypes;
  final ValueChanged<List<String>> onTypesSelected;
  final bool isReadOnly;

  const TruckTypeSelector({
    super.key,
    required this.colorScheme,
    required this.selectedTypes,
    required this.onTypesSelected,
    this.isReadOnly = false,
  });

  static const List<Map<String, dynamic>> truckTypes = [
    {'label': 'Box Truck', 'value': 'Box Truck', 'icon': Icons.local_shipping},
    {'label': 'Container', 'value': 'Container', 'icon': Icons.inventory_2},
    {'label': 'Flatbed', 'value': 'Flatbed', 'icon': Icons.agriculture},
    {'label': 'Refrigerated', 'value': 'Refrigerated', 'icon': Icons.ac_unit},
    {'label': 'Tanker', 'value': 'Tanker', 'icon': Icons.water_drop},
    {'label': 'Dump Truck', 'value': 'Dump Truck', 'icon': Icons.construction},
    {'label': 'Lowboy', 'value': 'Lowboy', 'icon': Icons.engineering},
    {
      'label': 'Car Carrier',
      'value': 'Car Carrier',
      'icon': Icons.directions_car,
    },
    {
      'label': 'Livestock Carrier',
      'value': 'Livestock Carrier',
      'icon': Icons.pets,
    },
    {'label': 'Bulk Carrier', 'value': 'Bulk Carrier', 'icon': Icons.grain},
    {'label': 'Specialized', 'value': 'Specialized', 'icon': Icons.star},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SizeManager.s8,
      runSpacing: SizeManager.s8,
      children: truckTypes.map((type) {
        final value = type['value'] as String;
        final isSelected = selectedTypes.contains(value);
        return _TruckTypeChip(
          colorScheme: colorScheme,
          label: type['label'] as String,
          value: value,
          icon: type['icon'] as IconData,
          isSelected: isSelected,
          isReadOnly: isReadOnly,
          onTap: isReadOnly
              ? null
              : () {
                  final updated = List<String>.from(selectedTypes);
                  if (isSelected) {
                    updated.remove(value);
                  } else {
                    updated.add(value);
                  }
                  onTypesSelected(updated);
                },
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
  final bool isReadOnly;
  final VoidCallback? onTap;

  const _TruckTypeChip({
    required this.colorScheme,
    required this.label,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.isReadOnly,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s12,
          vertical: SizeManager.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isReadOnly ? Colors.blue : AppColors.primary)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(SizeManager.r20),
          border: Border.all(
            color: isSelected
                ? (isReadOnly ? Colors.blue : AppColors.primary)
                : colorScheme.border,
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
            if (isReadOnly && isSelected) ...[
              const SizedBox(width: 4),
              Icon(Icons.lock_outline, size: 12, color: AppColors.white),
            ],
          ],
        ),
      ),
    );
  }
}
