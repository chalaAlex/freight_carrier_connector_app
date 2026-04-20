import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppColorScheme colorScheme;
  final String title;

  const GlobalAppBar({
    super.key,
    required this.colorScheme,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: colorScheme.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }
}
