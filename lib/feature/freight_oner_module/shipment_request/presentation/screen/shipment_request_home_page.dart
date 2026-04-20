import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/sent_requests_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/screen/shipment_request_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _tabStatuses = [
  'PENDING',
  'ACCEPTED',
  'REJECTED',
  'CANCELLED',
  'COMPLETED',
];

class ShipmentRequestHomePage extends StatefulWidget {
  const ShipmentRequestHomePage({super.key});

  @override
  State<ShipmentRequestHomePage> createState() =>
      _ShipmentRequestHomePageState();
}

class _ShipmentRequestHomePageState extends State<ShipmentRequestHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabStatuses.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    context.read<SentRequestsBloc>().add(const LoadSentRequests('PENDING'));
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    context.read<SentRequestsBloc>().add(
      LoadSentRequests(_tabStatuses[_tabController.index]),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  AppColorScheme get _cs {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColorScheme.dark : AppColorScheme.light;
  }

  @override
  Widget build(BuildContext context) {
    final cs = _cs;
    return Scaffold(
      backgroundColor: cs.background,
      body: Column(
        children: [
          _Header(cs: cs, tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabStatuses
                  .map((s) => _TabContent(status: s, cs: cs))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, Routes.createShipmentRequest),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final AppColorScheme cs;
  final TabController tabController;

  const _Header({required this.cs, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SizeManager.s16,
                SizeManager.s12,
                SizeManager.s16,
                0,
              ),
              child: Text(
                'My Requests',
                style: TextStyle(
                  color: cs.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: cs.textSecondary,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              tabs: _tabStatuses.map((s) => Tab(text: s)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab content ───────────────────────────────────────────────────────────

class _TabContent extends StatelessWidget {
  final String status;
  final AppColorScheme cs;

  const _TabContent({required this.status, required this.cs});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SentRequestsBloc, SentRequestsState>(
      builder: (context, state) {
        if (state is SentRequestsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SentRequestsError) {
          return _ErrorState(
            message: state.message,
            cs: cs,
            onRetry: () =>
                context.read<SentRequestsBloc>().add(LoadSentRequests(status)),
          );
        }
        if (state is SentRequestsLoaded && state.status == status) {
          if (state.requests.isEmpty) {
            return _EmptyState(status: status, cs: cs);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              SizeManager.s16,
              SizeManager.s16,
              SizeManager.s16,
              100,
            ),
            itemCount: state.requests.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: SizeManager.s12),
            itemBuilder: (_, i) =>
                _RequestCard(request: state.requests[i], cs: cs),
          );
        }
        return _EmptyState(status: status, cs: cs);
      },
    );
  }
}

// ── Request card ──────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final SentRequestEntity request;
  final AppColorScheme cs;

  const _RequestCard({required this.request, required this.cs});

  @override
  Widget build(BuildContext context) {
    final snap = request.freightSnapshots.isNotEmpty
        ? request.freightSnapshots.first
        : null;
    final carrier = request.carrier;
    final statusColor = _statusColor(request.status);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShipmentRequestDetail(request: request),
        ),
      ),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(SizeManager.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrier + status
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                    color: cs.textSecondary,
                  ),
                  const SizedBox(width: SizeManager.s8),
                  Expanded(
                    child: Text(
                      carrier != null
                          ? '${carrier.brand ?? ''} ${carrier.model ?? ''}'
                                .trim()
                          : 'No carrier assigned',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusBadge(label: request.status, color: statusColor),
                ],
              ),
              if (carrier?.plateNumber != null) ...[
                const SizedBox(height: SizeManager.s4),
                Text(
                  carrier!.plateNumber!,
                  style: TextStyle(fontSize: 12, color: cs.textSecondary),
                ),
              ],
              const SizedBox(height: SizeManager.s12),
              // Route
              Row(
                children: [
                  _RouteDot(color: const Color(0xFFFF6B00)),
                  const SizedBox(width: SizeManager.s8),
                  Expanded(
                    child: Text(
                      snap?.pickupCity ?? '—',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: cs.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 14, color: cs.textSecondary),
                  const SizedBox(width: SizeManager.s8),
                  _RouteDot(color: cs.textSecondary),
                  const SizedBox(width: SizeManager.s8),
                  Expanded(
                    child: Text(
                      snap?.deliveryCity ?? '—',
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
              // Price + review button
              Row(
                children: [
                  Text(
                    request.proposedPrice != null
                        ? 'ETB ${request.proposedPrice!.toStringAsFixed(0)}'
                        : '—',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (request.status == 'COMPLETED' && !request.isReviewed)
                    _ReviewButton(request: request),
                ],
              ),
            ],
          ),
        ),
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
      case 'COMPLETED':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

class _ReviewButton extends StatelessWidget {
  final SentRequestEntity request;
  const _ReviewButton({required this.request});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, Routes.submitReview, arguments: request),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(SizeManager.r6),
        ),
        child: const Text(
          'Rate',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

// ── Small helpers ─────────────────────────────────────────────────────────

class _RouteDot extends StatelessWidget {
  final Color color;
  const _RouteDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(SizeManager.r4),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String status;
  final AppColorScheme cs;
  const _EmptyState({required this.status, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: cs.border, shape: BoxShape.circle),
            child: Icon(
              Icons.inbox_outlined,
              size: 36,
              color: cs.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: SizeManager.s16),
          Text(
            'No ${status.toLowerCase()} requests',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: SizeManager.s8),
          Text(
            'Your ${status.toLowerCase()} requests will appear here',
            style: TextStyle(fontSize: 14, color: cs.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final AppColorScheme cs;
  final VoidCallback onRetry;
  const _ErrorState({
    required this.message,
    required this.cs,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: SizeManager.s16),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: cs.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SizeManager.s16),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
