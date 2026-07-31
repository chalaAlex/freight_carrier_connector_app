import 'package:clean_architecture/core/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Generic list-row shimmer  (avatar + two text lines + trailing)
// Used by: notifications, completed shipments, company profile, driver list,
//          driver detail, bid detail, payment status, wallet, wallet txns,
//          payment history
// ─────────────────────────────────────────────────────────────────────────────

class ListRowShimmer extends StatelessWidget {
  final int itemCount;
  final double avatarSize;
  final bool showTrailing;
  final EdgeInsets padding;

  const ListRowShimmer({
    super.key,
    this.itemCount = 6,
    this.avatarSize = 44,
    this.showTrailing = true,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final base = shimmerBase(context);
    final hi = shimmerHighlight(context);

    return AppShimmer(
      builder: (ctx, x) => ListView.separated(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _ListRowTile(
          shimmerX: x,
          base: base,
          hi: hi,
          avatarSize: avatarSize,
          showTrailing: showTrailing,
          titleWidth: 120.0 + (i % 3) * 30.0,
          subtitleWidth: 160.0 + (i % 4) * 20.0,
        ),
      ),
    );
  }
}

class _ListRowTile extends StatelessWidget {
  final double shimmerX;
  final Color base, hi;
  final double avatarSize;
  final bool showTrailing;
  final double titleWidth, subtitleWidth;

  const _ListRowTile({
    required this.shimmerX,
    required this.base,
    required this.hi,
    required this.avatarSize,
    required this.showTrailing,
    required this.titleWidth,
    required this.subtitleWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ShimmerBox(
            width: avatarSize,
            height: avatarSize,
            radius: avatarSize / 2,
            shimmerX: shimmerX,
            baseColor: base,
            highlightColor: hi,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: titleWidth,
                  height: 14,
                  shimmerX: shimmerX,
                  baseColor: base,
                  highlightColor: hi,
                  radius: 7,
                ),
                const SizedBox(height: 8),
                ShimmerBox(
                  width: subtitleWidth,
                  height: 11,
                  shimmerX: shimmerX,
                  baseColor: base,
                  highlightColor: hi,
                  radius: 5,
                ),
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: 12),
            ShimmerBox(
              width: 40,
              height: 14,
              shimmerX: shimmerX,
              baseColor: base,
              highlightColor: hi,
              radius: 7,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card shimmer  (image banner + text lines)
// Used by: my carriers, my bids
// ─────────────────────────────────────────────────────────────────────────────

class CardListShimmer extends StatelessWidget {
  final int itemCount;
  final bool hasBanner;

  const CardListShimmer({super.key, this.itemCount = 4, this.hasBanner = true});

  @override
  Widget build(BuildContext context) {
    final base = shimmerBase(context);
    final hi = shimmerHighlight(context);

    return AppShimmer(
      builder: (ctx, x) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) => _CardTile(
          shimmerX: x,
          base: base,
          hi: hi,
          hasBanner: hasBanner,
          line1Width: 140.0 + (i % 3) * 20.0,
          line2Width: 100.0 + (i % 2) * 30.0,
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final double shimmerX;
  final Color base, hi;
  final bool hasBanner;
  final double line1Width, line2Width;

  const _CardTile({
    required this.shimmerX,
    required this.base,
    required this.hi,
    required this.hasBanner,
    required this.line1Width,
    required this.line2Width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasBanner)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: ShimmerBox(
                width: double.infinity,
                height: 130,
                shimmerX: shimmerX,
                baseColor: base,
                highlightColor: hi,
                radius: 0,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: line1Width,
                  height: 15,
                  shimmerX: shimmerX,
                  baseColor: base,
                  highlightColor: hi,
                  radius: 7,
                ),
                const SizedBox(height: 10),
                ShimmerBox(
                  width: line2Width,
                  height: 12,
                  shimmerX: shimmerX,
                  baseColor: base,
                  highlightColor: hi,
                  radius: 6,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ShimmerBox(
                      width: 70,
                      height: 11,
                      shimmerX: shimmerX,
                      baseColor: base,
                      highlightColor: hi,
                      radius: 5,
                    ),
                    const SizedBox(width: 12),
                    ShimmerBox(
                      width: 70,
                      height: 11,
                      shimmerX: shimmerX,
                      baseColor: base,
                      highlightColor: hi,
                      radius: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carrier card shimmer  (horizontal: thumbnail left + info right)
// Used by: my carriers screen
// ─────────────────────────────────────────────────────────────────────────────

class CarrierCardListShimmer extends StatelessWidget {
  final int itemCount;
  const CarrierCardListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    final base = shimmerBase(context);
    final hi = shimmerHighlight(context);

    return AppShimmer(
      builder: (ctx, x) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) => _CarrierTile(
          shimmerX: x,
          base: base,
          hi: hi,
          nameWidth: 120.0 + (i % 3) * 20.0,
        ),
      ),
    );
  }
}

class _CarrierTile extends StatelessWidget {
  final double shimmerX;
  final Color base, hi;
  final double nameWidth;

  const _CarrierTile({
    required this.shimmerX,
    required this.base,
    required this.hi,
    required this.nameWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: ShimmerBox(
              width: 110,
              height: 110,
              shimmerX: shimmerX,
              baseColor: base,
              highlightColor: hi,
              radius: 0,
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShimmerBox(
                    width: nameWidth,
                    height: 14,
                    shimmerX: shimmerX,
                    baseColor: base,
                    highlightColor: hi,
                    radius: 7,
                  ),
                  ShimmerBox(
                    width: 80,
                    height: 11,
                    shimmerX: shimmerX,
                    baseColor: base,
                    highlightColor: hi,
                    radius: 5,
                  ),
                  ShimmerBox(
                    width: 100,
                    height: 11,
                    shimmerX: shimmerX,
                    baseColor: base,
                    highlightColor: hi,
                    radius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail page shimmer  (hero image + stacked info cards)
// Used by: driver detail, bid detail, payment status, company profile
// ─────────────────────────────────────────────────────────────────────────────

class DetailPageShimmer extends StatelessWidget {
  const DetailPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final base = shimmerBase(context);
    final hi = shimmerHighlight(context);

    return AppShimmer(
      builder: (ctx, x) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero block
            ShimmerBox(
              width: double.infinity,
              height: 180,
              shimmerX: x,
              baseColor: base,
              highlightColor: hi,
              radius: 16,
            ),
            const SizedBox(height: 20),
            // Info cards
            for (int i = 0; i < 3; i++) ...[
              _InfoCardShimmer(shimmerX: x, base: base, hi: hi, index: i),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoCardShimmer extends StatelessWidget {
  final double shimmerX;
  final Color base, hi;
  final int index;

  const _InfoCardShimmer({
    required this.shimmerX,
    required this.base,
    required this.hi,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 100,
            height: 13,
            shimmerX: shimmerX,
            baseColor: base,
            highlightColor: hi,
            radius: 6,
          ),
          const SizedBox(height: 12),
          ShimmerBox(
            width: double.infinity,
            height: 12,
            shimmerX: shimmerX,
            baseColor: base,
            highlightColor: hi,
            radius: 6,
          ),
          const SizedBox(height: 8),
          ShimmerBox(
            width: 180.0 + index * 20.0,
            height: 12,
            shimmerX: shimmerX,
            baseColor: base,
            highlightColor: hi,
            radius: 6,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wallet shimmer  (balance card + action buttons + transaction rows)
// ─────────────────────────────────────────────────────────────────────────────

class WalletShimmer extends StatelessWidget {
  const WalletShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final base = shimmerBase(context);
    final hi = shimmerHighlight(context);

    return AppShimmer(
      builder: (ctx, x) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance card
            ShimmerBox(
              width: double.infinity,
              height: 140,
              shimmerX: x,
              baseColor: base,
              highlightColor: hi,
              radius: 16,
            ),
            const SizedBox(height: 20),
            // Action buttons row
            Row(
              children: [
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 72,
                    shimmerX: x,
                    baseColor: base,
                    highlightColor: hi,
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 72,
                    shimmerX: x,
                    baseColor: base,
                    highlightColor: hi,
                    radius: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Section title
            ShimmerBox(
              width: 120,
              height: 14,
              shimmerX: x,
              baseColor: base,
              highlightColor: hi,
              radius: 7,
            ),
            const SizedBox(height: 12),
            // Transaction rows
            for (int i = 0; i < 4; i++) ...[
              _ListRowTile(
                shimmerX: x,
                base: base,
                hi: hi,
                avatarSize: 36,
                showTrailing: true,
                titleWidth: 100.0 + i * 20.0,
                subtitleWidth: 140.0 + i * 15.0,
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
