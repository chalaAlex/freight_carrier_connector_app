import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/theme/theme_cubit.dart';
import 'package:clean_architecture/core/theme/theme_state.dart';
import 'package:clean_architecture/feature/landing/presentation/screen/landing_detail_page.dart';

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
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildCarrierCard(
                title: 'Agricultural Logistics Specialist',
                price: '\$2.50',
                subPrice: '\$4.10',
                location: 'Denver, Colorado',
                category: 'AGRICULTURAL PRODUCTS',
                isFeatured: true,
                colorScheme: colorScheme,
              );
            },
          ),
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
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildCarrierCard(
                title: 'Agricultural Logistics Specialist',
                price: '\$2.50',
                subPrice: '\$4.10',
                location: 'Denver, Colorado',
                category: 'AGRICULTURAL PRODUCTS',
                isFeatured: true,
                colorScheme: colorScheme,
              );
            },
          ),
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
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildCarrierCard(
                title: 'Agricultural Logistics Specialist',
                price: '\$2.50',
                subPrice: '\$4.10',
                location: 'Denver, Colorado',
                category: 'AGRICULTURAL PRODUCTS',
                isFeatured: false,
                colorScheme: colorScheme,
              );
            },
          ),
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

  // Carrier Card
  Widget _buildCarrierCard({
    required String title,
    required String price,
    required String subPrice,
    required String location,
    required String category,
    required bool isFeatured,
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
                child: Image.network(
                  'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=400',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: colorScheme.border,
                      child: Icon(
                        Icons.local_shipping,
                        size: 50,
                        color: colorScheme.textSecondary,
                      ),
                    );
                  },
                ),
              ),
              if (isFeatured)
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
                        title,
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
                          price,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.textPrimary,
                          ),
                        ),
                        Text(
                          subPrice,
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
                        location,
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
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
