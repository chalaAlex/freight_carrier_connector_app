import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/feature/freight_oner_module/common/widgets/app_buttons.dart';
import 'package:clean_architecture/feature/freight_oner_module/common/widgets/role_option_card.dart';

enum UserRole { shipper, carrier }

class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  UserRole selectedRole = UserRole.shipper;

  void _selectRole(UserRole role) {
    setState(() => selectedRole = role);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.text;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeManager.screenHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: SizeManager.s40),

                    Text(
                      StringManager.welComeHeader,
                      style: text.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: SizeManager.s40),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SizeManager.descriptionHorizontalPadding,
                      ),
                      child: Text(
                        StringManager.welComeDescription,
                        style: text.bodyLarge?.copyWith(
                          color: colors.textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: SizeManager.s40),

                    RoleOptionCard(
                      title: StringManager.shipperTitle,
                      subtitle: StringManager.shipperSubtitle,
                      icon: Icons.inventory_2_outlined,
                      isSelected: selectedRole == UserRole.shipper,
                      onTap: () => _selectRole(UserRole.shipper),
                    ),

                    const SizedBox(height: SizeManager.s40),

                    RoleOptionCard(
                      title: StringManager.carrierTitle,
                      subtitle: StringManager.carrierSubtitle,
                      icon: Icons.local_shipping_outlined,
                      isSelected: selectedRole == UserRole.carrier,
                      onTap: () => _selectRole(UserRole.carrier),
                    ),

                    const SizedBox(height: SizeManager.s40),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: SizeManager.s40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      text: StringManager.continueBtn,
                      onPressed: () {
                        if (selectedRole == UserRole.shipper) {
                          Navigator.pushNamed(context, Routes.foSignupRoute);
                        } else {
                          Navigator.pushNamed(context, Routes.coSignupRoute);
                        }
                      },
                    ),

                    const SizedBox(height: SizeManager.s40),

                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.loginScreenRoute),
                      child: RichText(
                        text: TextSpan(
                          style: text.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                          children: [
                            const TextSpan(
                              text: StringManager.alreadyHaveAccount,
                            ),
                            TextSpan(
                              text: StringManager.login,
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
