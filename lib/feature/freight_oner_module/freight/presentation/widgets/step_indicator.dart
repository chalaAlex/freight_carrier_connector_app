import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class StepIndicator extends StatelessWidget {
  final AppColorScheme colorScheme;
  final int currentStep;
  final String stepDescription;

  const StepIndicator({
    super.key,
    required this.colorScheme,
    required this.currentStep,
    required this.stepDescription,
  });

  static const List<String> steps = [
    'Cargo Details',
    'Route & Schedule',
    'Requirements & Pricing',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $currentStep of ${steps.length}',
          style: TextStyle(
            color: colorScheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SizeManager.s8),
        Text(
          stepDescription,
          style: TextStyle(
            color: colorScheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: SizeManager.s12),
        Row(
          children: List.generate(
            steps.length,
            (index) => Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: index < currentStep
                            ? AppColors.primary
                            : colorScheme.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < steps.length - 1) const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
