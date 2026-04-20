import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/shipment_request_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/shipment_request_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/presentation/bloc/shipment_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ShipmentRequestDetail extends StatelessWidget {
  final SentRequestEntity request;

  const ShipmentRequestDetail({super.key, required this.request});

  AppColorScheme _cs(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColorScheme.dark : AppColorScheme.light;
  }

  void _showMenu(BuildContext context) {
    final isPending = request.status == 'PENDING';
    final label = isPending ? 'Cancel Request' : 'Mark as Completed';
    final icon = isPending ? Icons.cancel_outlined : Icons.check_circle_outline;
    final color = isPending ? AppColors.error : AppColors.success;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeManager.r16),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: SizeManager.s8),
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmAction(context, isPending);
            },
          ),
        ),
      ),
    );
  }

  void _confirmAction(BuildContext context, bool isPending) {
    final label = isPending ? 'Cancel Request' : 'Mark as Completed';
    final message = isPending
        ? 'Are you sure you want to cancel this request?'
        : 'Mark this shipment as completed?';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(label),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isPending) {
                context.read<ShipmentRequestBloc>().add(
                  CancelShipmentRequest(request.id),
                );
              } else {
                context.read<ShipmentRequestBloc>().add(
                  CompleteShipmentRequest(request.id),
                );
              }
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: isPending ? AppColors.error : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = _cs(context);
    final snap = request.freightSnapshots.isNotEmpty
        ? request.freightSnapshots.first
        : null;

    return BlocListener<ShipmentRequestBloc, ShipmentRequestState>(
      listener: (context, state) {
        if (state is ShipmentRequestActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context);
        } else if (state is ShipmentRequestError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: cs.background,
        appBar: AppBar(
          backgroundColor: cs.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cs.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Bid Overview',
            style: TextStyle(
              color: cs.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (request.status == 'PENDING' || request.status == 'ACCEPTED')
              IconButton(
                icon: Icon(Icons.more_vert, color: cs.textPrimary),
                onPressed: () => _showMenu(context),
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(SizeManager.s16),
          children: [
            _BidCard(request: request, cs: cs),
            const SizedBox(height: SizeManager.s12),
            if (snap != null) _RouteCard(snap: snap, cs: cs),
            if (snap != null) const SizedBox(height: SizeManager.s12),
            _ScheduleCard(createdAt: request.createdAt, cs: cs),
            const SizedBox(height: SizeManager.s12),
            if (snap != null) _CargoCard(snap: snap, cs: cs),
            const SizedBox(height: 100),
          ],
        ),
        bottomNavigationBar: request.status == 'COMPLETED'
            ? _BottomBar(request: request, cs: cs)
            : null,
      ),
    );
  }
}

// ── Bid card ──────────────────────────────────────────────────────────────

class _BidCard extends StatelessWidget {
  final SentRequestEntity request;
  final AppColorScheme cs;

  const _BidCard({required this.request, required this.cs});

  @override
  Widget build(BuildContext context) {
    final carrier = request.carrier;
    final price = request.proposedPrice?.toStringAsFixed(0) ?? '—';

    return _Card(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROPOSED BID',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: cs.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: SizeManager.s4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: price,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        TextSpan(
                          text: '  ETB',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: cs.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _StatusBadge(status: request.status),
            ],
          ),
          if (carrier != null) ...[
            const SizedBox(height: SizeManager.s16),
            const Divider(height: 1),
            const SizedBox(height: SizeManager.s16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: SizeManager.s12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${carrier.brand ?? ''} ${carrier.model ?? ''}'.trim(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.textPrimary,
                      ),
                    ),
                    if (carrier.plateNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        carrier.plateNumber!,
                        style: TextStyle(fontSize: 12, color: cs.textSecondary),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Route card ────────────────────────────────────────────────────────────

class _RouteCard extends StatelessWidget {
  final SentSnapshotEntity snap;
  final AppColorScheme cs;

  const _RouteCard({required this.snap, required this.cs});

  @override
  Widget build(BuildContext context) {
    return _Card(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(icon: Icons.alt_route, label: 'Route Details', cs: cs),
          const SizedBox(height: SizeManager.s16),
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: cs.border,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: SizeManager.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LocationRow(
                        label: 'PICKUP',
                        value: snap.pickupCity ?? '—',
                        cs: cs,
                      ),
                      const SizedBox(height: SizeManager.s16),
                      _LocationRow(
                        label: 'DROPOFF',
                        value: snap.deliveryCity ?? '—',
                        cs: cs,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme cs;

  const _LocationRow({
    required this.label,
    required this.value,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: cs.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: cs.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Schedule card ─────────────────────────────────────────────────────────

class _ScheduleCard extends StatelessWidget {
  final DateTime createdAt;
  final AppColorScheme cs;

  const _ScheduleCard({required this.createdAt, required this.cs});

  @override
  Widget build(BuildContext context) {
    return _Card(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.calendar_today_outlined,
            label: 'Schedule',
            cs: cs,
          ),
          const SizedBox(height: SizeManager.s16),
          _InfoBox(
            label: 'CREATED DATE',
            value: DateFormat('MMM d, yyyy').format(createdAt),
            cs: cs,
          ),
        ],
      ),
    );
  }
}

// ── Cargo card ────────────────────────────────────────────────────────────

class _CargoCard extends StatelessWidget {
  final SentSnapshotEntity snap;
  final AppColorScheme cs;

  const _CargoCard({required this.snap, required this.cs});

  @override
  Widget build(BuildContext context) {
    return _Card(
      cs: cs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.inventory_2_outlined,
            label: 'Cargo Information',
            cs: cs,
          ),
          const SizedBox(height: SizeManager.s16),
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  label: 'TYPE',
                  value: snap.cargoType ?? '—',
                  cs: cs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final SentRequestEntity request;
  final AppColorScheme cs;

  const _BottomBar({required this.request, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        SizeManager.s16,
        SizeManager.s12,
        SizeManager.s16,
        SizeManager.s24,
      ),
      decoration: BoxDecoration(
        color: cs.background,
        border: Border(top: BorderSide(color: cs.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: request.isReviewed
              ? null
              : () => Navigator.pushNamed(
                  context,
                  Routes.submitReview,
                  arguments: request,
                ),
          icon: const Icon(Icons.star_outline, size: 18),
          label: Text(
            request.isReviewed ? 'Already Reviewed' : 'Leave a Review',
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeManager.r12),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final AppColorScheme cs;
  final Widget child;

  const _Card({required this.cs, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColorScheme cs;

  const _SectionTitle({
    required this.icon,
    required this.label,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: SizeManager.s8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cs.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme cs;

  const _InfoBox({required this.label, required this.value, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s12),
      decoration: BoxDecoration(
        color: cs.background,
        borderRadius: BorderRadius.circular(SizeManager.r10),
        border: Border.all(color: cs.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: cs.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: SizeManager.s4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: cs.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status.toUpperCase()) {
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
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SizeManager.r16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '${status.toUpperCase()} BIDDING',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
