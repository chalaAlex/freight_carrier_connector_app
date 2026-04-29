import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:flutter/material.dart';

class CarrierCardLoadingWidget extends StatefulWidget {
  /// Number of skeleton cards to show
  final int count;

  const CarrierCardLoadingWidget({super.key, this.count = 5});

  @override
  State<CarrierCardLoadingWidget> createState() =>
      _CarrierCardLoadingWidgetState();
}

class _CarrierCardLoadingWidgetState extends State<CarrierCardLoadingWidget>
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
    final cs = Theme.of(context).brightness == Brightness.dark
        ? AppColorScheme.dark
        : AppColorScheme.light;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s16,
        vertical: SizeManager.s8,
      ),
      itemCount: widget.count,
      itemBuilder: (_, __) => _buildSkeletonCard(cs),
    );
  }

  Widget _buildSkeletonCard(AppColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: SizeManager.s16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(SizeManager.r16),
              bottomLeft: Radius.circular(SizeManager.r16),
            ),
            child: _shimmerBox(cs, width: 110, height: 110, radius: 0),
          ),
          // Right content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(SizeManager.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row: brand+model + availability badge
                  Row(
                    children: [
                      Expanded(
                        child: _shimmerBox(
                          cs,
                          width: double.infinity,
                          height: 16,
                        ),
                      ),
                      const SizedBox(width: SizeManager.s8),
                      _shimmerBox(
                        cs,
                        width: 52,
                        height: 22,
                        radius: SizeManager.r12,
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s8),
                  // Plate number
                  _shimmerBox(cs, width: 90, height: 12),
                  const SizedBox(height: SizeManager.s8),
                  // Location + price row
                  Row(
                    children: [
                      _shimmerBox(cs, width: 14, height: 14, radius: 7),
                      const SizedBox(width: SizeManager.s4),
                      Expanded(
                        child: _shimmerBox(
                          cs,
                          width: double.infinity,
                          height: 12,
                        ),
                      ),
                      const SizedBox(width: SizeManager.s8),
                      _shimmerBox(cs, width: 50, height: 18),
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

  Widget _shimmerBox(
    AppColorScheme cs, {
    required double width,
    required double height,
    double radius = SizeManager.r6,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [cs.border, cs.surface, cs.border],
              stops: [
                _stop(_animation.value - 1),
                _stop(_animation.value),
                _stop(_animation.value + 1),
              ],
            ),
          ),
        );
      },
    );
  }

  double _stop(double value) => ((value + 2) / 4).clamp(0.0, 1.0);
}
