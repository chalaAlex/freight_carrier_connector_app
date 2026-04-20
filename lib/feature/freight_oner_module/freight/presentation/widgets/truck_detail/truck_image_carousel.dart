import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

class TruckImageCarousel extends StatefulWidget {
  final List<String> images;

  const TruckImageCarousel({super.key, required this.images});

  @override
  State<TruckImageCarousel> createState() => _TruckImageCarouselState();
}

class _TruckImageCarouselState extends State<TruckImageCarousel> {
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
    if (widget.images.isEmpty) {
      return _buildPlaceholder();
    }

    return Stack(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.images[index],
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
                      color: AppColors.primary,
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: SizeManager.s16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => _buildIndicator(index == _currentPage),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: isActive ? AppColors.primary : AppColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 250,
      // ignore: deprecated_member_use
      color: AppColors.lightGrey.withOpacity(0.3),
      child: Center(
        child: Icon(Icons.local_shipping, size: 64, color: AppColors.grey),
      ),
    );
  }
}
