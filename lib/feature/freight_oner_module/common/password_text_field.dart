import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: onToggle,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Password must be at least 8 characters';
        return null;
      },
    );
  }
}
