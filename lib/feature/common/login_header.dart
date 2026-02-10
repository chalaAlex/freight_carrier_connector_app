import 'package:animate_do/animate_do.dart';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/assets/app_assets.dart';
import 'package:clean_architecture/feature/common/animated_decorative_element.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.text;

    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // ignore: deprecated_member_use
            colors.primary.withOpacity(0.85),
            // ignore: deprecated_member_use
            colors.primary.withOpacity(0.65),
          ],
        ),
        image: DecorationImage(
          image: AssetImage(AppImages.background),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Stack(
        children: [
          AnimatedDecorativeElement(
            left: 30,
            top: 0,
            width: 100,
            height: 180,
            image: AppImages.light1,
            delayMs: 900,
          ),
          AnimatedDecorativeElement(
            left: 150,
            top: 0,
            width: 90,
            height: 140,
            image: AppImages.light2,
            delayMs: 1100,
          ),
          AnimatedDecorativeElement(
            right: 40,
            top: 100,
            width: 90,
            height: 140,
            image: AppImages.clock,
            delayMs: 1100,
          ),
          Center(
            child: FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Text(
                  'Welcome Back',
                  style: text.headlineMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
