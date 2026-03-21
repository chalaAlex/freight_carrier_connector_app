import 'package:clean_architecture/feature/common/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/theme/theme_state.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_bloc.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_event.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_state.dart';
import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:clean_architecture/feature/freight/presentation/screen/truck_detail_screen.dart';
import 'package:clean_architecture/feature/carrier/presentation/bloc/favourite_bloc.dart';
import 'package:clean_architecture/feature/carrier/presentation/bloc/favourite_event.dart';
import 'package:clean_architecture/feature/carrier/presentation/bloc/favourite_state.dart';
import 'package:clean_architecture/core/di.dart' as di;

class LandingDetailPage extends StatefulWidget {
  final String title;

  const LandingDetailPage({super.key, required this.title});

  @override
  State<LandingDetailPage> createState() => _LandingDetailPageState();
}

class _LandingDetailPageState extends State<LandingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<FeaturedCarrierBloc>()..add(const LoadFeaturedCarriers()),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final isDark =
              themeState.themeMode == ThemeMode.dark ||
              (themeState.themeMode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness == Brightness.dark);
          final colorScheme = isDark
              ? AppColorScheme.dark
              : AppColorScheme.light;

          return Scaffold(
            backgroundColor: colorScheme.background,
            appBar: GlobalAppBar(colorScheme: colorScheme, title: ''),
            body: BlocBuilder<FeaturedCarrierBloc, FeaturedCarrierState>(
              builder: (context, state) {
                if (state is FeaturedCarrierLoading) {
                  return _buildLoadingList();
                }

                if (state is FeaturedCarrierError) {
                  return _buildErrorState(state.message, colorScheme);
                }

                if (state is FeaturedCarrierLoaded) {
                  if (state.carriers.isEmpty) {
                    return _buildEmptyState(colorScheme);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.carriers.length,
                    itemBuilder: (context, index) {
                      final carrier = state.carriers[index];
                      return BlocProvider(
                        create: (_) => di.sl<FavouriteBloc>(),
                        child: _buildTruckCardFromEntity(
                          carrier: carrier,
                          colorScheme: colorScheme,
                        ),
                      );
                    },
                  );
                }

                return _buildEmptyState(colorScheme);
              },
            ),
          );
        },
      ),
    );
  }

  // App Bar
  // PreferredSizeWidget _buildAppBar(AppColorScheme colorScheme) {
  //   return AppBar(
  //     backgroundColor: colorScheme.surface,
  //     elevation: 0,
  //     leading: IconButton(
  //       icon: Icon(Icons.arrow_back, color: colorScheme.textPrimary),
  //       onPressed: () => Navigator.pop(context),
  //     ),
  //     title: Text(
  //       widget.title,
  //       style: TextStyle(
  //         color: colorScheme.textPrimary,
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     actions: [
  //       // TODO: Implement search functionality
  //       IconButton(
  //         icon: Icon(Icons.search, color: colorScheme.textPrimary),
  //         onPressed: () {},
  //       ),
  //     ],
  //   );
  // }

  // Truck Card from Entity
  Widget _buildTruckCardFromEntity({
    required CarrierTruckEntity carrier,
    required AppColorScheme colorScheme,
  }) {
    // Calculate price display (using loadCapacity as a base for demo)
    final basePrice = (carrier.loadCapacity / 10000 * 2.5).toStringAsFixed(2);
    final maxPrice = (carrier.loadCapacity / 10000 * 3.5).toStringAsFixed(2);

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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TruckDetailScreen(truckId: carrier.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: carrier.image.isNotEmpty
                    ? Image.network(
                        carrier.image.first,
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                        // TODO: Add proper error handling and placeholder image
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder(colorScheme);
                        },
                      )
                    : _buildImagePlaceholder(colorScheme),
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
                            '${carrier.brand} ${carrier.model}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        BlocBuilder<FavouriteBloc, FavouriteState>(
                          builder: (context, favState) {
                            final isFav = favState is FavouriteSuccess
                                ? favState.isFavourite
                                : favState is FavouriteInitial
                                ? favState.isFavourite
                                : false;
                            final isLoading = favState is FavouriteLoading;
                            return IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colorScheme.textSecondary,
                                      ),
                                    )
                                  : Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav
                                          ? Colors.red
                                          : colorScheme.textSecondary,
                                      size: 20,
                                    ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (isFav) {
                                        context.read<FavouriteBloc>().add(
                                          DisableFavourite(carrier.id),
                                        );
                                      } else {
                                        context.read<FavouriteBloc>().add(
                                          MakeFavourite(carrier.id),
                                        );
                                      }
                                    },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      carrier.company,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // const Icon(
                        //   Icons.star,
                        //   color: AppColors.warning,
                        //   size: 16,
                        // ),
                        // const SizedBox(width: 4),
                        // Text(
                        //   '4.8', // TODO: Add rating to entity
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w600,
                        //     color: colorScheme.textPrimary,
                        //   ),
                        // ),
                        // const SizedBox(width: 4),
                        // Text(
                        //   '(${carrier.driver.length * 25})', // Mock review count
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: colorScheme.textSecondary,
                        //   ),
                        // ),
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
                              '\$$basePrice - \$$maxPrice',
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
                            color: carrier.isAvailable
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            carrier.isAvailable ? 'Available' : 'On Trip',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: carrier.isAvailable
                                  ? AppColors.success
                                  : AppColors.grey,
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
      ),
    );
  }

  // Image Placeholder
  Widget _buildImagePlaceholder(AppColorScheme colorScheme) {
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
  }

  // Loading List
  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 116,
                height: 140,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 150,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 100,
                        color: Colors.grey[400],
                      ),
                      const Spacer(),
                      Container(height: 16, width: 80, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Error State
  Widget _buildErrorState(String message, AppColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 24),
            Text(
              'Failed to load carriers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: colorScheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<FeaturedCarrierBloc>().add(
                  const LoadFeaturedCarriers(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState(AppColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: colorScheme.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'No carriers found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'There are no carriers available in this category at the moment.',
              style: TextStyle(fontSize: 14, color: colorScheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
