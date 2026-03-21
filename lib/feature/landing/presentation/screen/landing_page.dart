import 'package:clean_architecture/feature/freight/presentation/screen/truck_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/theme/theme_state.dart';
import 'package:clean_architecture/feature/landing/presentation/screen/landing_detail_page.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_bloc.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_event.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_state.dart';
import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/recommended_company_bloc.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/recommended_company_event.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/recommended_company_state.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/top_rated_company_bloc.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/top_rated_company_event.dart';
import 'package:clean_architecture/feature/company/presentation/bloc/top_rated_company_state.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';
import 'package:clean_architecture/feature/company/presentation/screen/company_profile.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPromoBanner(),
                const SizedBox(height: 24),
                _buildFeaturedCarriers(colorScheme),
                const SizedBox(height: 24),
                _buildTopRatedCompanies(colorScheme),
                const SizedBox(height: 24),
                _buildRecommendedCompanies(colorScheme),
                const SizedBox(height: 24),
                _buildListFreightSection(colorScheme),
                const SizedBox(height: 24),
              ],
            ),
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
        icon: Icon(Icons.menu, color: colorScheme.textPrimary),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: colorScheme.textPrimary,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  // Promo Banner
  Widget _buildPromoBanner() {
    return Container(
      width: 350,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B4FFF), Color(0xFF7B6FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SHIP SMARTER WITH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'OUR NEW APP',
              style: TextStyle(
                color: Color(0xFFFFB800),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'TRACK FREIGHT IN REAL-TIME 24/7',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Featured Carriers Section
  Widget _buildFeaturedCarriers(AppColorScheme colorScheme) {
    return Column(
      children: [
        _buildSectionHeader('Featured Carriers', colorScheme),
        const SizedBox(height: 12),
        BlocBuilder<FeaturedCarrierBloc, FeaturedCarrierState>(
          builder: (context, state) {
            if (state is FeaturedCarrierLoading) {
              return _buildLoadingCarriers();
            }

            if (state is FeaturedCarrierError) {
              return _buildErrorState(state.message, colorScheme);
            }

            if (state is FeaturedCarrierLoaded) {
              if (state.carriers.isEmpty) {
                return _buildEmptyState(
                  'No featured carriers available',
                  colorScheme,
                );
              }

              return SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.carriers.length,
                  itemBuilder: (context, index) {
                    final carrier = state.carriers[index];
                    return _buildCarrierCardFromEntity(
                      carrier: carrier,
                      colorScheme: colorScheme,
                    );
                  },
                ),
              );
            }

            return _buildEmptyState('No data available', colorScheme);
          },
        ),
      ],
    );
  }

  // Top Rated Companies Section
  Widget _buildTopRatedCompanies(AppColorScheme colorScheme) {
    return Column(
      children: [
        _buildSectionHeader('Top Rated Companies', colorScheme),
        const SizedBox(height: 12),
        BlocBuilder<TopRatedCompanyBloc, TopRatedCompanyState>(
          builder: (context, state) {
            if (state is TopRatedCompanyLoading) {
              return _buildLoadingCarriers();
            }

            if (state is TopRatedCompanyError) {
              return _buildErrorState(state.message, colorScheme);
            }

            if (state is TopRatedCompanyLoaded) {
              if (state.companies.isEmpty) {
                return _buildEmptyState(
                  'No top rated companies available',
                  colorScheme,
                );
              }

              return SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.companies.length,
                  itemBuilder: (context, index) {
                    final company = state.companies[index];
                    return _buildCompanyCard(
                      company: company,
                      colorScheme: colorScheme,
                    );
                  },
                ),
              );
            }

            return _buildEmptyState('No data available', colorScheme);
          },
        ),
      ],
    );
  }

  // Recommended Companies Section
  Widget _buildRecommendedCompanies(AppColorScheme colorScheme) {
    return Column(
      children: [
        _buildSectionHeader('Recommended Companies', colorScheme),
        const SizedBox(height: 12),
        BlocBuilder<RecommendedCompanyBloc, RecommendedCompanyState>(
          builder: (context, state) {
            if (state is RecommendedCompanyLoading) {
              return _buildLoadingCarriers();
            }

            if (state is RecommendedCompanyError) {
              return _buildErrorState(state.message, colorScheme);
            }

            if (state is RecommendedCompanyLoaded) {
              if (state.companies.isEmpty) {
                return _buildEmptyState(
                  'No recommended companies available',
                  colorScheme,
                );
              }

              // final recommendedCompanies = state.companies.take(3).toList();

              return SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.companies.length,
                  itemBuilder: (context, index) {
                    final company = state.companies[index];
                    return _buildCompanyCard(
                      company: company,
                      colorScheme: colorScheme,
                    );
                  },
                ),
              );
            }
            return _buildEmptyState('No data available', colorScheme);
          },
        ),
      ],
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title, AppColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.textPrimary,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LandingDetailPage(title: title),
                ),
              );
            },
            child: const Text(
              'See All',
              style: TextStyle(
                color: Color(0xFF4285F4),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Carrier Card from Entity
  Widget _buildCarrierCardFromEntity({
    required CarrierTruckEntity carrier,
    required AppColorScheme colorScheme,
  }) {
    // Calculate price display (using loadCapacity as a base for demo)
    final basePrice = (carrier.loadCapacity / 10000 * 2.5).toStringAsFixed(2);
    final maxPrice = (carrier.loadCapacity / 10000 * 3.5).toStringAsFixed(2);

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: carrier.image.isNotEmpty
                      ? Image.network(
                          carrier.image.first,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder(colorScheme);
                          },
                        )
                      : _buildImagePlaceholder(colorScheme),
                ),
                if (carrier.isVerified)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB800),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'VERIFIED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: colorScheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$$basePrice',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.textPrimary,
                            ),
                          ),
                          Text(
                            '\$$maxPrice',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
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
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colorScheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${carrier.operatingCorrider.startLocation} → ${carrier.operatingCorrider.destinationLocation}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: carrier.isAvailable
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          carrier.isAvailable ? 'Available' : 'Busy',
                          style: TextStyle(
                            fontSize: 10,
                            color: carrier.isAvailable
                                ? AppColors.success
                                : AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${carrier.loadCapacity}kg capacity',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
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
      height: 140,
      width: double.infinity,
      color: colorScheme.border,
      child: Icon(
        Icons.local_shipping,
        size: 50,
        color: colorScheme.textSecondary,
      ),
    );
  }

  // Company Image Placeholder
  Widget _buildCompanyImagePlaceholder(AppColorScheme colorScheme) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.8), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.business,
          size: 60,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  // Company Card (for recommended companies)
  Widget _buildCompanyCard({
    required CompanyEntity company,
    required AppColorScheme colorScheme,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyProfile(company: company),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header with Image
            Container(
              height: 140,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  // Background Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child:
                        company.bannerImage != null &&
                            company.bannerImage!.isNotEmpty
                        ? Image.network(
                            company.bannerImage!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildCompanyImagePlaceholder(colorScheme);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return _buildCompanyImagePlaceholder(colorScheme);
                            },
                          )
                        : _buildCompanyImagePlaceholder(colorScheme),
                  ),
                  // Gradient Overlay
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                  ),
                  if (company.isVerified)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'VERIFIED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.legalEntityName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colorScheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${company.headOfficeAddress.city}, ${company.headOfficeAddress.regionState}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            company.ratingAverage.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${company.ratingQuantity})',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: company.isActive
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${company.fleetSize} Trucks',
                          style: TextStyle(
                            fontSize: 10,
                            color: company.isActive
                                ? AppColors.success
                                : AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Loading State
  Widget _buildLoadingCarriers() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
                Padding(
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
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Error State
  Widget _buildErrorState(String message, AppColorScheme colorScheme) {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: colorScheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Retry all data loading
                context.read<FeaturedCarrierBloc>().add(
                  const LoadFeaturedCarriers(),
                );
                context.read<RecommendedCompanyBloc>().add(
                  const LoadRecommendedCompanies(),
                );
                context.read<TopRatedCompanyBloc>().add(
                  const LoadTopRatedCompanies(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState(String message, AppColorScheme colorScheme) {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: colorScheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: colorScheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // List Freight Section
  Widget _buildListFreightSection(AppColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Your Freight for Free',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Have cargo that needs moving? List it on our platform for free and instantly. Contact us to list your shipment today.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.inventory_2_outlined,
            size: 60,
            color: Color(0xFFFFB800),
          ),
        ],
      ),
    );
  }
}
