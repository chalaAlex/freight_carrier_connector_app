import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/my_bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/my_bids_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBidsScreen extends StatelessWidget {
  const MyBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyBidsCubit>()..load(),
      child: const _MyBidsView(),
    );
  }
}

class _MyBidsView extends StatefulWidget {
  const _MyBidsView();
  @override
  State<_MyBidsView> createState() => _MyBidsViewState();
}

class _MyBidsViewState extends State<_MyBidsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _statuses = [
    'All',
    'PENDING',
    'ACCEPTED',
    'REJECTED',
    'CANCELLED',
    'EXPIRED',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MyBidEntity> _filter(List<MyBidEntity> all, int i) {
    if (i == 0) return all;
    return all.where((b) => b.status == _statuses[i]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Bids',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: _statuses.map((s) => Tab(text: s)).toList(),
        ),
      ),
      body: BlocBuilder<MyBidsCubit, MyBidsState>(
        builder: (context, state) {
          if (state is MyBidsLoading || state is MyBidsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyBidsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<MyBidsCubit>().load(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is MyBidsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: List.generate(_statuses.length, (i) {
                final list = _filter(state.bids, i);
                if (list.isEmpty) {
                  return _EmptyTab(status: _statuses[i]);
                }
                return RefreshIndicator(
                  onRefresh: () async => context.read<MyBidsCubit>().load(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: list.length,
                    itemBuilder: (_, idx) => _BidCard(bid: list[idx]),
                  ),
                );
              }),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Bid Card — styled like _RequestCard ─────────────────────────────────────

class _BidCard extends StatelessWidget {
  final MyBidEntity bid;
  const _BidCard({required this.bid});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark
        ? const _CS(
            surface: Color(0xFF1E1E2E),
            textPrimary: Colors.white,
            textSecondary: Color(0xFF9E9EBE),
            border: Color(0xFF2E2E4E),
          )
        : const _CS(
            surface: Colors.white,
            textPrimary: Color(0xFF111111),
            textSecondary: Color(0xFF7A7A7A),
            border: Color(0xFFEEEEF8),
          );

    final statusColor = _statusColor(bid.status);
    final hasImage = bid.freightImage != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image banner
          if (hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(SizeManager.r12),
              ),
              child: Image.network(
                bid.freightImage!,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _BannerPlaceholder(),
              ),
            )
          else
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(SizeManager.r12),
              ),
              child: const _BannerPlaceholder(),
            ),

          Padding(
            padding: const EdgeInsets.all(SizeManager.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cargo title + status badge
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: cs.textSecondary,
                    ),
                    const SizedBox(width: SizeManager.s8),
                    Expanded(
                      child: Text(
                        bid.freightCargoDescription ?? 'Freight',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: cs.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _StatusBadge(label: bid.status, color: statusColor),
                  ],
                ),
                if (bid.freightCargoType != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    bid.freightCargoType!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
                const SizedBox(height: SizeManager.s12),

                // Route
                if (bid.freightPickup != null || bid.freightDropoff != null)
                  Row(
                    children: [
                      _RouteDot(color: AppColors.primary),
                      const SizedBox(width: SizeManager.s8),
                      Expanded(
                        child: Text(
                          bid.freightPickup ?? '—',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: cs.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: cs.textSecondary,
                      ),
                      const SizedBox(width: SizeManager.s8),
                      _RouteDot(color: cs.textSecondary),
                      const SizedBox(width: SizeManager.s8),
                      Expanded(
                        child: Text(
                          bid.freightDropoff ?? '—',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: cs.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: SizeManager.s12),

                // Bid amount + listed price + date
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Bid',
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.textSecondary,
                            letterSpacing: 0.4,
                          ),
                        ),
                        Text(
                          'ETB ${bid.bidAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (bid.freightPricingAmount != null) ...[
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Listed',
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.textSecondary,
                              letterSpacing: 0.4,
                            ),
                          ),
                          Text(
                            'ETB ${bid.freightPricingAmount!.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Spacer(),
                    if (bid.createdAt != null)
                      Text(
                        _formatDate(bid.createdAt!),
                        style: TextStyle(fontSize: 11, color: cs.textSecondary),
                      ),
                  ],
                ),

                // Message
                if (bid.message.isNotEmpty) ...[
                  const SizedBox(height: SizeManager.s8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: cs.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 14,
                          color: cs.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            bid.message,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'ACCEPTED':
        return const Color(0xFF10B981);
      case 'REJECTED':
        return const Color(0xFFEF4444);
      case 'CANCELLED':
        return const Color(0xFF6B7280);
      case 'EXPIRED':
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

// ─── Small helpers ────────────────────────────────────────────────────────────

class _CS {
  final Color surface, textPrimary, textSecondary, border;
  const _CS({
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
  });
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
      ),
    ),
  );
}

class _RouteDot extends StatelessWidget {
  final Color color;
  const _RouteDot({required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();
  @override
  Widget build(BuildContext context) => Container(
    height: 130,
    width: double.infinity,
    color: const Color(0xFF1A1A2E),
    child: const Icon(
      Icons.local_shipping_outlined,
      size: 40,
      color: Colors.white24,
    ),
  );
}

class _EmptyTab extends StatelessWidget {
  final String status;
  const _EmptyTab({required this.status});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.gavel_outlined, size: 48, color: AppColors.grey),
        const SizedBox(height: 12),
        Text(
          status == 'All' ? 'No bids yet' : 'No $status bids',
          style: context.text.bodyMedium?.copyWith(color: AppColors.grey),
        ),
      ],
    ),
  );
}
