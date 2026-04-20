import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';

class TruckDetailLoadingWidget extends StatefulWidget {
  const TruckDetailLoadingWidget({super.key});

  @override
  State<TruckDetailLoadingWidget> createState() =>
      _TruckDetailLoadingWidgetState();
}

class _TruckDetailLoadingWidgetState extends State<TruckDetailLoadingWidget>
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // Header with image shimmer
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorScheme.surface,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
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
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: colorScheme.textPrimary),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildShimmerBox(
                animation: _animation,
                colorScheme: colorScheme,
                height: 300,
                width: double.infinity,
                borderRadius: 0,
              ),
            ),
          ),
          // Content shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(SizeManager.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price section shimmer
                  _buildShimmerSection(
                    colorScheme: colorScheme,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildShimmerBox(
                                  animation: _animation,
                                  colorScheme: colorScheme,
                                  height: 28,
                                  width: 200,
                                ),
                                const SizedBox(height: 8),
                                _buildShimmerBox(
                                  animation: _animation,
                                  colorScheme: colorScheme,
                                  height: 16,
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildShimmerBox(
                                animation: _animation,
                                colorScheme: colorScheme,
                                height: 28,
                                width: 80,
                              ),
                              const SizedBox(height: 4),
                              _buildShimmerBox(
                                animation: _animation,
                                colorScheme: colorScheme,
                                height: 14,
                                width: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s16),

                  // Owner section shimmer
                  _buildShimmerSection(
                    colorScheme: colorScheme,
                    children: [
                      Row(
                        children: [
                          _buildShimmerCircle(
                            animation: _animation,
                            colorScheme: colorScheme,
                            radius: 24,
                          ),
                          const SizedBox(width: SizeManager.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildShimmerBox(
                                  animation: _animation,
                                  colorScheme: colorScheme,
                                  height: 16,
                                  width: 120,
                                ),
                                const SizedBox(height: 4),
                                _buildShimmerBox(
                                  animation: _animation,
                                  colorScheme: colorScheme,
                                  height: 12,
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                          _buildShimmerBox(
                            animation: _animation,
                            colorScheme: colorScheme,
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s24),

                  // Specifications title
                  _buildShimmerBox(
                    animation: _animation,
                    colorScheme: colorScheme,
                    height: 20,
                    width: 120,
                  ),
                  const SizedBox(height: SizeManager.s16),

                  // Specifications cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildShimmerSection(
                          colorScheme: colorScheme,
                          children: [
                            _buildShimmerBox(
                              animation: _animation,
                              colorScheme: colorScheme,
                              height: 28,
                              width: 28,
                            ),
                            const SizedBox(height: SizeManager.s12),
                            _buildShimmerBox(
                              animation: _animation,
                              colorScheme: colorScheme,
                              height: 10,
                              width: 80,
                            ),
                            const SizedBox(height: 4),
                            _buildShimmerBox(
                              animation: _animation,
                              colorScheme: colorScheme,
                              height: 16,
                              width: 60,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: SizeManager.s12),
                      Expanded(
                        child: _buildShimmerSection(
                          colorScheme: colorScheme,
                          children: [
                            _buildShimmerBox(
                              animation: _animation,
                              colorScheme: colorScheme,
                              height: 28,
                              width: 28,
                            ),
                            const SizedBox(height: SizeManager.s12),
                            _buildShimmerBox(
                              animation: _animation,
                              colorScheme: colorScheme,
                              height: 10,
                              width: 80,
                            ),
                            const SizedBox(height: 4),
                            _buildShimmerBox(
                              animation: _animation,
                              colorScheme: colorScheme,
                              height: 16,
                              width: 60,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s24),

                  // Features title
                  _buildShimmerBox(
                    animation: _animation,
                    colorScheme: colorScheme,
                    height: 20,
                    width: 140,
                  ),
                  const SizedBox(height: SizeManager.s16),

                  // Features chips
                  Wrap(
                    spacing: SizeManager.s12,
                    runSpacing: SizeManager.s12,
                    children: [
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 36,
                        width: 100,
                      ),
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 36,
                        width: 120,
                      ),
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 36,
                        width: 90,
                      ),
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 36,
                        width: 110,
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s24),

                  // About title
                  _buildShimmerBox(
                    animation: _animation,
                    colorScheme: colorScheme,
                    height: 20,
                    width: 120,
                  ),
                  const SizedBox(height: SizeManager.s12),

                  // About text
                  _buildShimmerBox(
                    animation: _animation,
                    colorScheme: colorScheme,
                    height: 14,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 8),
                  _buildShimmerBox(
                    animation: _animation,
                    colorScheme: colorScheme,
                    height: 14,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 8),
                  _buildShimmerBox(
                    animation: _animation,
                    colorScheme: colorScheme,
                    height: 14,
                    width: 200,
                  ),
                  const SizedBox(height: SizeManager.s24),

                  // Reviews title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 20,
                        width: 80,
                      ),
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 16,
                        width: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s12),

                  // Review card
                  _buildShimmerSection(
                    colorScheme: colorScheme,
                    children: [
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 16,
                        width: 150,
                      ),
                      const SizedBox(height: SizeManager.s12),
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 14,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 8),
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 14,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 8),
                      _buildShimmerBox(
                        animation: _animation,
                        colorScheme: colorScheme,
                        height: 14,
                        width: 180,
                      ),
                      const SizedBox(height: SizeManager.s12),
                      Row(
                        children: [
                          _buildShimmerCircle(
                            animation: _animation,
                            colorScheme: colorScheme,
                            radius: 12,
                          ),
                          const SizedBox(width: 8),
                          _buildShimmerBox(
                            animation: _animation,
                            colorScheme: colorScheme,
                            height: 12,
                            width: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSection({
    required AppColorScheme colorScheme,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        border: Border.all(color: colorScheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildShimmerBox({
    required Animation<double> animation,
    required AppColorScheme colorScheme,
    required double height,
    required double width,
    double borderRadius = SizeManager.r6,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
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

  Widget _buildShimmerCircle({
    required Animation<double> animation,
    required AppColorScheme colorScheme,
    required double radius,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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

  double _calculateStop(double value) {
    return (value + 2) / 4; // Normalize to 0-1 range
  }
}
