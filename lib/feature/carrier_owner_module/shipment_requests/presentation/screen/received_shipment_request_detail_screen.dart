import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/widgets/shimmer_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Shown when a carrier owner taps a SHIPMENT_REQUEST_RECEIVED notification.
/// Fetches the full request by ID, then lets the carrier Accept or Reject it.
class ReceivedShipmentRequestDetailScreen extends StatefulWidget {
  final String requestId;
  const ReceivedShipmentRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<ReceivedShipmentRequestDetailScreen> createState() =>
      _ReceivedShipmentRequestDetailScreenState();
}

class _ReceivedShipmentRequestDetailScreenState
    extends State<ReceivedShipmentRequestDetailScreen> {
  Map<String, dynamic>? _request;
  bool _loading = true;
  String? _error;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // GET /shipmentRequests/received returns all received requests.
      // We filter by the specific requestId from the notification.
      final res = await sl<Dio>().get('/shipmentRequests/received');
      final data = res.data as Map<String, dynamic>;
      final list = ((data['data']?['requests']) as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      final found = list.cast<Map<String, dynamic>?>().firstWhere(
        (r) => r?['_id'] == widget.requestId,
        orElse: () => null,
      );
      if (mounted) {
        setState(() {
          _request = found;
          _loading = false;
          if (found == null) _error = 'Request not found.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e is DioException
              ? (e.response?.data?['message'] ?? 'Failed to load request')
              : e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _accept() =>
      _doAction('accept', 'Request accepted successfully.');
  Future<void> _reject() => _doAction('reject', 'Request rejected.');

  Future<void> _doAction(String action, String successMsg) async {
    setState(() => _actionLoading = true);
    try {
      await sl<Dio>().post('/shipmentRequests/${widget.requestId}/$action');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMsg), backgroundColor: AppColors.success),
      );
      // Refresh to show updated status
      setState(() => _actionLoading = false);
      _fetch();
    } catch (e) {
      if (!mounted) return;
      final msg = e is DioException
          ? (e.response?.data?['message'] ?? 'Action failed')
          : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.error),
      );
      setState(() => _actionLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shipment Request',
          style: TextStyle(
            color: cs.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _buildBody(cs),
    );
  }

  Widget _buildBody(AppColorScheme cs) {
    if (_loading) return const DetailPageShimmer();

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: cs.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _fetch, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_request == null) return const SizedBox.shrink();

    final status = (_request!['status'] as String? ?? 'PENDING').toUpperCase();
    final isPending = status == 'PENDING';
    final snapshots = (_request!['freightSnapshots'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final contact = _request!['freightOwnerContact'] as Map<String, dynamic>?;
    final proposedPrice = (_request!['proposedPrice'] as num?)?.toDouble();
    final createdAt = _request!['createdAt'] != null
        ? DateTime.tryParse(_request!['createdAt'] as String)
        : null;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SizeManager.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status banner
                _StatusBanner(status: status, cs: cs),
                const SizedBox(height: SizeManager.s16),

                // Price card
                if (proposedPrice != null)
                  _InfoCard(
                    cs: cs,
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Proposed Price',
                    child: Text(
                      'ETB ${proposedPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                if (proposedPrice != null)
                  const SizedBox(height: SizeManager.s12),

                // Freight snapshots
                ...snapshots.map((snap) => _SnapshotCard(snap: snap, cs: cs)),

                // Freight owner contact
                if (contact != null) ...[
                  const SizedBox(height: SizeManager.s12),
                  _ContactCard(contact: contact, cs: cs),
                ],

                // Created at
                if (createdAt != null) ...[
                  const SizedBox(height: SizeManager.s12),
                  _InfoCard(
                    cs: cs,
                    icon: Icons.schedule_outlined,
                    title: 'Received',
                    child: Text(
                      DateFormat('MMM d, y · HH:mm').format(createdAt),
                      style: TextStyle(color: cs.textPrimary, fontSize: 14),
                    ),
                  ),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // Action buttons — only shown for PENDING requests
        if (isPending)
          _ActionBar(
            cs: cs,
            loading: _actionLoading,
            onAccept: _accept,
            onReject: _reject,
          ),
      ],
    );
  }
}

// ── Status banner ─────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final String status;
  final AppColorScheme cs;
  const _StatusBanner({required this.status, required this.cs});

  Color get _color {
    switch (status) {
      case 'ACCEPTED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.error;
      case 'CANCELLED':
        return AppColors.grey;
      case 'COMPLETED':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFFF59E0B); // PENDING
    }
  }

  IconData get _icon {
    switch (status) {
      case 'ACCEPTED':
        return Icons.check_circle_outline;
      case 'REJECTED':
        return Icons.cancel_outlined;
      case 'CANCELLED':
        return Icons.block_outlined;
      case 'COMPLETED':
        return Icons.verified_outlined;
      default:
        return Icons.hourglass_empty;
    }
  }

  String get _description {
    switch (status) {
      case 'ACCEPTED':
        return 'You accepted this request. Await payment from the freight owner.';
      case 'REJECTED':
        return 'You rejected this request.';
      case 'CANCELLED':
        return 'This request was cancelled by the freight owner.';
      case 'COMPLETED':
        return 'This shipment has been completed.';
      default:
        return 'Waiting for your response.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(_icon, size: 44, color: _color),
          const SizedBox(height: 8),
          Text(
            status,
            style: TextStyle(
              color: _color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _description,
            style: TextStyle(color: cs.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Snapshot card ─────────────────────────────────────────────────────────────

class _SnapshotCard extends StatelessWidget {
  final Map<String, dynamic> snap;
  final AppColorScheme cs;
  const _SnapshotCard({required this.snap, required this.cs});

  String _loc(Map<String, dynamic>? loc) {
    if (loc == null) return '—';
    final city = loc['city'] as String? ?? '';
    final region = loc['region'] as String? ?? '';
    return [city, region].where((s) => s.isNotEmpty).join(', ').isEmpty
        ? '—'
        : [city, region].where((s) => s.isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final pickup = snap['pickupLocation'] as Map<String, dynamic>?;
    final delivery = snap['deliveryLocation'] as Map<String, dynamic>?;
    final cargoType = snap['cargoType'] as String? ?? '—';
    final weight = snap['weight'];
    final quantity = snap['quantity'];
    final pickupDate = snap['pickupDate'] != null
        ? DateTime.tryParse(snap['pickupDate'] as String)
        : null;
    final deliveryDate = snap['deliveryDate'] != null
        ? DateTime.tryParse(snap['deliveryDate'] as String)
        : null;
    final special = snap['specialRequirements'] as String?;

    return _InfoCard(
      cs: cs,
      icon: Icons.inventory_2_outlined,
      title: 'Freight Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route
          _RouteRow(pickup: _loc(pickup), delivery: _loc(delivery), cs: cs),
          const SizedBox(height: SizeManager.s12),
          // Cargo specs
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _Chip(label: 'Type', value: cargoType, cs: cs),
              if (weight != null)
                _Chip(label: 'Weight', value: '$weight kg', cs: cs),
              if (quantity != null)
                _Chip(label: 'Qty', value: '$quantity units', cs: cs),
            ],
          ),
          // Dates
          if (pickupDate != null || deliveryDate != null) ...[
            const SizedBox(height: SizeManager.s12),
            if (pickupDate != null)
              _DateRow(label: 'Pickup', date: pickupDate, cs: cs),
            if (deliveryDate != null)
              _DateRow(label: 'Delivery by', date: deliveryDate, cs: cs),
          ],
          // Special requirements
          if (special != null && special.isNotEmpty) ...[
            const SizedBox(height: SizeManager.s8),
            Text(
              'Note: $special',
              style: TextStyle(
                fontSize: 12,
                color: cs.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  final String pickup, delivery;
  final AppColorScheme cs;
  const _RouteRow({
    required this.pickup,
    required this.delivery,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            pickup,
            style: TextStyle(
              color: cs.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 16, color: AppColors.grey),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: Color(0xFFFF6B00),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            delivery,
            style: TextStyle(
              color: cs.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label, value;
  final AppColorScheme cs;
  const _Chip({required this.label, required this.value, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: cs.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: cs.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final DateTime date;
  final AppColorScheme cs;
  const _DateRow({required this.label, required this.date, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: cs.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: cs.textSecondary),
          ),
          Text(
            DateFormat('MMM d, y').format(date),
            style: TextStyle(
              fontSize: 12,
              color: cs.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contact card ──────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final Map<String, dynamic> contact;
  final AppColorScheme cs;
  const _ContactCard({required this.contact, required this.cs});

  @override
  Widget build(BuildContext context) {
    final name = contact['name'] as String? ?? '—';
    final company = contact['companyName'] as String?;
    final email = contact['email'] as String?;
    final phone = contact['phone'] as String?;

    return _InfoCard(
      cs: cs,
      icon: Icons.person_outline,
      title: 'Freight Owner',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: cs.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          if (company != null && company.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              company,
              style: TextStyle(color: cs.textSecondary, fontSize: 13),
            ),
          ],
          const SizedBox(height: 8),
          if (phone != null)
            _ContactRow(icon: Icons.phone_outlined, value: phone, cs: cs),
          if (email != null)
            _ContactRow(icon: Icons.email_outlined, value: email, cs: cs),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final AppColorScheme cs;
  const _ContactRow({
    required this.icon,
    required this.value,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: cs.textSecondary),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(fontSize: 13, color: cs.textPrimary)),
        ],
      ),
    );
  }
}

// ── Shared info card ──────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final AppColorScheme cs;
  final IconData icon;
  final String title;
  final Widget child;
  const _InfoCard({
    required this.cs,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: cs.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s12),
          child,
        ],
      ),
    );
  }
}

// ── Action bar ────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final AppColorScheme cs;
  final bool loading;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  const _ActionBar({
    required this.cs,
    required this.loading,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.border)),
      ),
      child: Row(
        children: [
          // Reject
          Expanded(
            child: OutlinedButton.icon(
              onPressed: loading ? null : onReject,
              icon: const Icon(Icons.close, size: 18),
              label: const Text(
                'Reject',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Accept
          Expanded(
            child: ElevatedButton.icon(
              onPressed: loading ? null : onAccept,
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(
                loading ? 'Processing…' : 'Accept',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
