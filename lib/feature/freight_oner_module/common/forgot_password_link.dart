import 'package:animate_do/animate_do.dart';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.text;

    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            );
          },
          child: Text(
            'Forgot Password?',
            style: text.bodyMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
