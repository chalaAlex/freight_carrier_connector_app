import 'package:flutter/material.dart';

/// Shared shimmer animation controller + painter used by all skeleton widgets.
/// Wrap any layout in [AppShimmerBox] to get the sliding highlight effect.

// ── Painter ───────────────────────────────────────────────────────────────────

class ShimmerPainter extends CustomPainter {
  final Color baseColor;
  final Color highlightColor;
  final double shimmerX;

  const ShimmerPainter({
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
  bool shouldRepaint(ShimmerPainter old) => old.shimmerX != shimmerX;
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
}

// ── Base animated widget ──────────────────────────────────────────────────────

/// Drives the shimmer animation and exposes [shimmerX] to child builders.
class AppShimmer extends StatefulWidget {
  final Widget Function(BuildContext context, double shimmerX) builder;
  const AppShimmer({super.key, required this.builder});

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (ctx, _) => widget.builder(ctx, _anim.value),
    );
  }
}

// ── Convenience box ───────────────────────────────────────────────────────────

/// A single shimmer rectangle. Use inside an [AppShimmer] builder.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color baseColor;
  final Color highlightColor;
  final double shimmerX;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    required this.shimmerX,
    required this.baseColor,
    required this.highlightColor,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: ShimmerPainter(
            baseColor: baseColor,
            highlightColor: highlightColor,
            shimmerX: shimmerX,
          ),
        ),
      ),
    );
  }
}

// ── Helper to resolve colors from theme ──────────────────────────────────────

Color shimmerBase(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E8);
}

Color shimmerHighlight(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5FF);
}
