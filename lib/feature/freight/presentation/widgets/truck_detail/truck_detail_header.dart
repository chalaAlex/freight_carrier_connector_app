import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';

class TruckDetailHeader extends StatefulWidget {
  final TruckEntity truck;

  const TruckDetailHeader({super.key, required this.truck});

  @override
  State<TruckDetailHeader> createState() => _TruckDetailHeaderState();
}

class _TruckDetailHeaderState extends State<TruckDetailHeader> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;
    final images = widget.truck.image ?? [];
    final hasImages = images.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.textPrimary,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.share, color: colorScheme.textPrimary),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImages)
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.white,
                        ),
                      );
                    },
                  );
                },
              )
            else
              _buildPlaceholder(),
            // Gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Availability badge
            Positioned(bottom: 16, left: 16, child: _buildAvailabilityBadge()),
            // Page indicators
            if (hasImages && images.length > 1)
              Positioned(
                bottom: 16,
                right: 16,
                child: _buildPageIndicators(images.length),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Container(
      color: colorScheme.border,
      child: Center(
        child: Icon(
          Icons.local_shipping,
          size: 80,
          color: colorScheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge() {
    final isAvailable = widget.truck.isAvailable ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.primary : AppColors.error,
        borderRadius: BorderRadius.circular(SizeManager.r6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            color: AppColors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            isAvailable ? 'AVAILABLE NOW' : 'UNAVAILABLE',
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(SizeManager.r12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          count,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: index == _currentPage ? 8 : 6,
            height: index == _currentPage ? 8 : 6,
            decoration: BoxDecoration(
              color: index == _currentPage
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
