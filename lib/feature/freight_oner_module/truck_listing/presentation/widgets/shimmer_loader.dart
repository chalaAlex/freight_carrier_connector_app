import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

/// A shimmer loading widget that displays skeleton cards during initial data fetch.
///
/// Displays 3-5 skeleton cards that mimic the [TruckCard] layout with a
/// shimmer animation effect to indicate loading state.
class ShimmerLoader extends StatefulWidget {
  final int cardCount;

  const ShimmerLoader({super.key, this.cardCount = 4})
    : assert(
        cardCount >= 3 && cardCount <= 5,
        'cardCount must be between 3 and 5',
      );

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(SizeManager.s16),
      itemCount: widget.cardCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: SizeManager.s16),
          child: _ShimmerCard(animation: _animation),
        );
      },
    );
  }
}

/// Individual shimmer card that mimics the TruckCard layout
class _ShimmerCard extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerCard({required this.animation});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Card(
      elevation: SizeManager.cardElevation,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeManager.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section shimmer
          _buildImageShimmer(colorScheme),
          // Info section shimmer
          _buildInfoShimmer(colorScheme),
        ],
      ),
    );
  }

  /// Builds the shimmer effect for the image section
  Widget _buildImageShimmer(AppColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeManager.cardRadius),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            height: SizeManager.imageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  colorScheme.border,
                  colorScheme.surface,
                  colorScheme.border,
                ],
                stops: [
                  _calculateStop(animation.value - 1),
                  _calculateStop(animation.value),
                  _calculateStop(animation.value + 1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the shimmer effect for the info section
  Widget _buildInfoShimmer(AppColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Truck model name shimmer
          _buildShimmerBox(width: 200, height: 24, colorScheme: colorScheme),
          const SizedBox(height: SizeManager.s8),

          // Company name shimmer
          _buildShimmerBox(width: 150, height: 16, colorScheme: colorScheme),
          const SizedBox(height: SizeManager.s16),

          // Pricing shimmer
          _buildShimmerBox(width: 250, height: 20, colorScheme: colorScheme),
          const SizedBox(height: SizeManager.s16),

          // Specs row shimmer
          Row(
            children: [
              _buildShimmerBox(width: 80, height: 16, colorScheme: colorScheme),
              const SizedBox(width: SizeManager.s24),
              _buildShimmerBox(
                width: 100,
                height: 16,
                colorScheme: colorScheme,
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s12),

          // Location shimmer
          _buildShimmerBox(width: 180, height: 16, colorScheme: colorScheme),
          const SizedBox(height: SizeManager.s16),

          // Action buttons shimmer
          Row(
            children: [
              Expanded(
                child: _buildShimmerBox(
                  width: double.infinity,
                  height: SizeManager.buttonHeight,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: SizeManager.s12),
              Expanded(
                child: _buildShimmerBox(
                  width: double.infinity,
                  height: SizeManager.buttonHeight,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a shimmer box with animated gradient
  Widget _buildShimmerBox({
    required double width,
    required double height,
    required AppColorScheme colorScheme,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeManager.r6),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colorScheme.border,
                colorScheme.surface,
                colorScheme.border,
              ],
              stops: [
                _calculateStop(animation.value - 1),
                _calculateStop(animation.value),
                _calculateStop(animation.value + 1),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Calculates the gradient stop position based on animation value
  double _calculateStop(double value) {
    return (value + 2) / 4; // Normalize to 0-1 range
  }
}
