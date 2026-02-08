// import 'package:flutter/material.dart';

// enum UserRole { shipper, carrier }

// class RoleOptionCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const RoleOptionCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected
//                 ? theme.colorScheme.primary
//                 : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             if (isSelected)
//               BoxShadow(
//                 color: theme.colorScheme.primary.withOpacity(0.15),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Left Icon Container
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.primary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: theme.colorScheme.primary, size: 24),
//             ),

//             const SizedBox(width: 14),

//             // Text Section
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Radio Indicator
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected
//                       ? theme.colorScheme.primary
//                       : Colors.grey.shade400,
//                   width: 2,
//                 ),
//               ),
//               child: isSelected
//                   ? Center(
//                       child: Container(
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.primary,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     )
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:flutter/material.dart';

class RoleOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.08) : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: context.text.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colors.primary,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}