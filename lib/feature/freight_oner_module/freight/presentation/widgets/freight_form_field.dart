import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class FreightFormField extends StatelessWidget {
  final AppColorScheme colorScheme;
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const FreightFormField({
    super.key,
    required this.colorScheme,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.inputFormatters,
    this.validator,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          validator: validator,
          style: TextStyle(color: colorScheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colorScheme.textSecondary),
            filled: true,
            fillColor: colorScheme.surface,
            suffixIcon: suffixIcon,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeManager.r6),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SizeManager.s12,
              vertical: SizeManager.s12,
            ),
          ),
        ),
      ],
    );
  }
}
