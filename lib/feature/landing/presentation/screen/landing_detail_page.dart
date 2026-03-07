import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/theme/theme_state.dart';

class LandingDetailPage extends StatefulWidget {
  final String title;

  const LandingDetailPage({super.key, required this.title});

  @override
  State<LandingDetailPage> createState() => _LandingDetailPageState();
}

class _LandingDetailPageState extends State<LandingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark =
            themeState.themeMode == ThemeMode.dark ||
            (themeState.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        final colorScheme = isDark ? AppColorScheme.dark : AppColorScheme.light;

        return Scaffold(
          backgroundColor: colorScheme.background,
          appBar: _buildAppBar(colorScheme),
          // TODO: Replace with actual data from API/repository
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildTruckCard(index: index, colorScheme: colorScheme);
            },
          ),
        );
      },
    );
  }

  // App Bar
  PreferredSizeWidget _buildAppBar(AppColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          color: colorScheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // TODO: Implement search functionality
        IconButton(
          icon: Icon(Icons.search, color: colorScheme.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  // Truck Card
  Widget _buildTruckCard({
    required int index,
    required AppColorScheme colorScheme,
  }) {
    // TODO: Replace with actual truck data model from repository
    final trucks = [
      {
        'name': 'Volvo FH16 Reefer',
        'company': 'Global Logistics Co.',
        'rating': 4.9,
        'reviews': 128,
        'priceMin': 3.50,
        'priceMax': 4.10,
        'status': 'Available',
        'statusColor': AppColors.success,
        'isFavorite': true,
        'isVerified': true,
        'image':
            'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=400',
      },
      {
        'name': 'Peterbilt 579 Flatbed',
        'company': 'Mountain Express',
        'rating': 4.7,
        'reviews': 84,
        'priceMin': 2.80,
        'priceMax': 3.20,
        'status': 'In 2h',
        'statusColor': AppColors.warning,
        'isFavorite': false,
        'isVerified': true,
        'image':
            'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=400',
      },
      {
        'name': 'Freightliner Cascadia',
        'company': 'Swift Haulage Ltd.',
        'rating': 4.9,
        'reviews': 210,
        'priceMin': 2.40,
        'priceMax': 2.90,
        'status': 'Available',
        'statusColor': AppColors.success,
        'isFavorite': false,
        'isVerified': true,
        'image':
            'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=400',
      },
      {
        'name': 'Kenworth T680',
        'company': 'Prime Carriers',
        'rating': 4.5,
        'reviews': 56,
        'priceMin': 3.10,
        'priceMax': 3.60,
        'status': 'On Trip',
        'statusColor': AppColors.grey,
        'isFavorite': false,
        'isVerified': true,
        'image':
            'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=400',
      },
    ];

    final truck = trucks[index % trucks.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // TODO: Add onTap navigation to truck detail page
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                truck['image'] as String,
                width: 100,
                height: 120,
                fit: BoxFit.cover,
                // TODO: Add proper error handling and placeholder image
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 120,
                    color: colorScheme.border,
                    child: Icon(
                      Icons.local_shipping,
                      size: 40,
                      color: colorScheme.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
          // Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          truck['name'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        // TODO: Implement favorite/unfavorite functionality
                        icon: Icon(
                          (truck['isFavorite'] as bool)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: (truck['isFavorite'] as bool)
                              ? AppColors.error
                              : colorScheme.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    truck['company'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${truck['rating']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${truck['reviews']})',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${truck['priceMin']} - \$${truck['priceMax']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: (truck['statusColor'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          truck['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: truck['statusColor'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
