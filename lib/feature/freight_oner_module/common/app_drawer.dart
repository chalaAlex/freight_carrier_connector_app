import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/theme/theme_state.dart';
import 'package:clean_architecture/core/token/toke_local_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.appColors;
    final loginState = context.watch<LoginBloc>().state;
    final user = loginState.user?.data;

    final firstName = user?.firstName ?? '';
    final lastName = user?.lastName ?? '';
    final fullName = '$firstName $lastName'.trim();
    final email = user?.email ?? '';
    final role = user?.role ?? '';
    final initials = [
      if (firstName.isNotEmpty) firstName[0],
      if (lastName.isNotEmpty) lastName[0],
    ].join().toUpperCase();

    return Drawer(
      backgroundColor: cs.background,
      child: SafeArea(
        child: Column(
          children: [
            // ── Profile header ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              color: cs.surface,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cs.primary,
                    child: Text(
                      initials.isEmpty ? '?' : initials,
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty ? 'User' : fullName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: cs.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _roleLabel(role),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Menu items ──────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.notificationRoute);
                    },
                  ),
                  // _DrawerTile(
                  //   icon: Icons.help_outline,
                  //   label: 'Help & Support',
                  //   onTap: () => Navigator.pop(context),
                  // ),
                  const Divider(indent: 16, endIndent: 16),

                  // ── Theme toggle ──────────────────────────────────────
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      final isDark =
                          themeState.themeMode == ThemeMode.dark ||
                          (themeState.themeMode == ThemeMode.system &&
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark);
                      return _DrawerTile(
                        icon: isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        label: isDark ? 'Light Mode' : 'Dark Mode',
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) =>
                              context.read<ThemeCubit>().toggle(),
                          activeColor: cs.primary,
                        ),
                        onTap: () => context.read<ThemeCubit>().toggle(),
                      );
                    },
                  ),

                  const Divider(indent: 16, endIndent: 16),
                ],
              ),
            ),

            // ── Logout ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.error,
                    side: BorderSide(color: cs.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _roleLabel(String role) => switch (role) {
    'carrier_owner' => 'Carrier Owner',
    'freight_owner' => 'Freight Owner',
    'admin' => 'Admin',
    _ => role,
  };

  Future<void> _logout(BuildContext context) async {
    Navigator.pop(context); // close drawer
    await sl<TokenLocalDataSource>().clearToken();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginScreenRoute,
        (_) => false,
      );
    }
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.appColors;
    return ListTile(
      leading: Icon(icon, color: cs.textSecondary, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: cs.textPrimary,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      horizontalTitleGap: 8,
    );
  }
}
