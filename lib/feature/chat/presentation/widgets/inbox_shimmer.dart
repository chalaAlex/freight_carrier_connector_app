import 'package:flutter/material.dart';

/// Shimmer placeholder that mirrors the layout of [_RoomTile] in InboxScreen.
class InboxShimmer extends StatefulWidget {
  final int itemCount;
  const InboxShimmer({super.key, this.itemCount = 6});

  @override
  State<InboxShimmer> createState() => _InboxShimmerState();
}

class _InboxShimmerState extends State<InboxShimmer>
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
      builder: (context, _) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.itemCount,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => _InboxTileShimmer(
          shimmerX: _animation.value,
          titleWidth: 120.0 + (i % 3) * 30.0,
          subtitleWidth: 160.0 + (i % 4) * 20.0,
        ),
      ),
    );
  }
}

class _InboxTileShimmer extends StatelessWidget {
  final double shimmerX;
  final double titleWidth;
  final double subtitleWidth;

  const _InboxTileShimmer({
    required this.shimmerX,
    required this.titleWidth,
    required this.subtitleWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E8);
    final highlight = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF5F5FF);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar circle
          _shimmerBox(
            width: 46,
            height: 46,
            base: base,
            highlight: highlight,
            radius: 23,
          ),
          const SizedBox(width: 14),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(
                  width: titleWidth,
                  height: 14,
                  base: base,
                  highlight: highlight,
                  radius: 7,
                ),
                const SizedBox(height: 8),
                _shimmerBox(
                  width: subtitleWidth,
                  height: 11,
                  base: base,
                  highlight: highlight,
                  radius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Trailing date + optional badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _shimmerBox(
                width: 36,
                height: 10,
                base: base,
                highlight: highlight,
                radius: 5,
              ),
              const SizedBox(height: 6),
              _shimmerBox(
                width: 20,
                height: 20,
                base: base,
                highlight: highlight,
                radius: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required Color base,
    required Color highlight,
    required double radius,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _ShimmerPainter(
            baseColor: base,
            highlightColor: highlight,
            shimmerX: shimmerX,
          ),
        ),
      ),
    );
  }
}

// ── Shared painter (same as FreightCardShimmer) ───────────────────────────

class _ShimmerPainter extends CustomPainter {
  final Color baseColor;
  final Color highlightColor;
  final double shimmerX;

  const _ShimmerPainter({
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
  bool shouldRepaint(_ShimmerPainter old) => old.shimmerX != shimmerX;
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
}
