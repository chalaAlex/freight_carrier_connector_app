import 'package:flutter/material.dart';

/// A shimmer placeholder that mirrors the layout of [FreightCard].
class FreightCardShimmer extends StatefulWidget {
  const FreightCardShimmer({super.key});

  @override
  State<FreightCardShimmer> createState() => _FreightCardShimmerState();
}

class _FreightCardShimmerState extends State<FreightCardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => _ShimmerCard(shimmerX: _animation.value),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double shimmerX;

  const _ShimmerCard({required this.shimmerX});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E8);
    final highlightColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF5F5FF);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: _shimmerBox(
              width: double.infinity,
              height: 160,
              baseColor: baseColor,
              highlightColor: highlightColor,
              shimmerX: shimmerX,
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      _shimmerBox(
                        width: 160,
                        height: 16,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        shimmerX: shimmerX,
                        radius: 8,
                      ),
                      const SizedBox(height: 10),
                      // Date + bids row
                      Row(
                        children: [
                          _shimmerBox(
                            width: 60,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 6,
                          ),
                          const SizedBox(width: 12),
                          _shimmerBox(
                            width: 60,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 6,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _shimmerBox(
                      width: 80,
                      height: 16,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      shimmerX: shimmerX,
                      radius: 8,
                    ),
                    const SizedBox(height: 6),
                    _shimmerBox(
                      width: 50,
                      height: 10,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      shimmerX: shimmerX,
                      radius: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(height: 1, color: baseColor),
          ),

          // Route + button row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Route row
                      Row(
                        children: [
                          _shimmerBox(
                            width: 8,
                            height: 8,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 4,
                          ),
                          const SizedBox(width: 6),
                          _shimmerBox(
                            width: 70,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 6,
                          ),
                          const SizedBox(width: 8),
                          _shimmerBox(
                            width: 14,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 4,
                          ),
                          const SizedBox(width: 8),
                          _shimmerBox(
                            width: 8,
                            height: 8,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 4,
                          ),
                          const SizedBox(width: 6),
                          _shimmerBox(
                            width: 70,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 6,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Weight + date row
                      Row(
                        children: [
                          _shimmerBox(
                            width: 55,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 6,
                          ),
                          const SizedBox(width: 12),
                          _shimmerBox(
                            width: 55,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            shimmerX: shimmerX,
                            radius: 6,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Place Bid button placeholder
                _shimmerBox(
                  width: 96,
                  height: 40,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  shimmerX: shimmerX,
                  radius: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
    required double shimmerX,
    double radius = 4,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _ShimmerPainter(
            baseColor: baseColor,
            highlightColor: highlightColor,
            shimmerX: shimmerX,
          ),
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final Color baseColor;
  final Color highlightColor;
  final double shimmerX;

  _ShimmerPainter({
    required this.baseColor,
    required this.highlightColor,
    required this.shimmerX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [baseColor, highlightColor, baseColor],
        stops: const [0.0, 0.5, 1.0],
        transform: _SlidingGradientTransform(shimmerX),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      oldDelegate.shimmerX != shimmerX;
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

/// A list of [FreightCardShimmer] items shown while loading.
class FreightListingShimmer extends StatelessWidget {
  final int itemCount;

  const FreightListingShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, __) => const FreightCardShimmer(),
    );
  }
}
