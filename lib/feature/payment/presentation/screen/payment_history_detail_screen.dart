import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentHistoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> payment;
  const PaymentHistoryDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    final status = (payment['status'] as String? ?? 'PENDING').toUpperCase();
    final gateway = (payment['gateway'] as String? ?? '').toUpperCase();
    final totalAmount = (payment['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final platformFee = (payment['platformFee'] as num?)?.toDouble() ?? 0.0;
    final carrierAmount = (payment['carrierAmount'] as num?)?.toDouble() ?? 0.0;
    final outTradeNo = payment['outTradeNo'] as String? ?? '—';
    final bookingType = (payment['bookingType'] as String? ?? '—')
        .toUpperCase();
    final paidAt = _parseDate(payment['paidAt']);
    final releasedAt = _parseDate(payment['releasedAt']);
    final releaseAt = _parseDate(payment['releaseAt']);
    final createdAt = _parseDate(payment['createdAt']);

    final statusColor = _statusColor(status);
    final gatewayColor = _gatewayColor(gateway);

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
          'Payment Details',
          style: TextStyle(
            color: cs.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status hero ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Icon(_statusIcon(status), size: 48, color: statusColor),
                  const SizedBox(height: 10),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _statusDescription(status),
                    style: TextStyle(color: cs.textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Amount breakdown ─────────────────────────────────────────
            _SectionCard(
              cs: cs,
              title: 'Amount Breakdown',
              icon: Icons.account_balance_wallet_outlined,
              children: [
                _DetailRow(
                  label: 'Total Amount',
                  value: 'ETB ${totalAmount.toStringAsFixed(2)}',
                  cs: cs,
                  bold: true,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  label: 'Platform Fee (10%)',
                  value: '− ETB ${platformFee.toStringAsFixed(2)}',
                  cs: cs,
                  valueColor: AppColors.error,
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _DetailRow(
                  label: 'Carrier Receives',
                  value: 'ETB ${carrierAmount.toStringAsFixed(2)}',
                  cs: cs,
                  valueColor: AppColors.success,
                  bold: true,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Payment method ───────────────────────────────────────────
            _SectionCard(
              cs: cs,
              title: 'Payment Method',
              icon: Icons.payment_outlined,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: gatewayColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _gatewayIcon(gateway),
                        color: gatewayColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gateway.isEmpty ? 'Unknown' : _gatewayLabel(gateway),
                          style: TextStyle(
                            color: cs.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          _gatewaySubtitle(gateway),
                          style: TextStyle(
                            color: cs.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _DetailRow(label: 'Booking Type', value: bookingType, cs: cs),
              ],
            ),

            const SizedBox(height: 14),

            // ── Timeline ─────────────────────────────────────────────────
            _SectionCard(
              cs: cs,
              title: 'Timeline',
              icon: Icons.timeline_outlined,
              children: [
                if (createdAt != null)
                  _TimelineRow(
                    label: 'Created',
                    date: createdAt,
                    color: cs.textSecondary,
                    icon: Icons.add_circle_outline,
                  ),
                if (paidAt != null) ...[
                  _TimelineDivider(cs: cs),
                  _TimelineRow(
                    label: 'Payment Confirmed',
                    date: paidAt,
                    color: const Color(0xFF2196F3),
                    icon: Icons.lock_outline,
                  ),
                ],
                if (releaseAt != null && status == 'HELD') ...[
                  _TimelineDivider(cs: cs),
                  _TimelineRow(
                    label: 'Auto-release At',
                    date: releaseAt,
                    color: AppColors.warning,
                    icon: Icons.schedule_outlined,
                  ),
                ],
                if (releasedAt != null) ...[
                  _TimelineDivider(cs: cs),
                  _TimelineRow(
                    label: 'Released to Carrier',
                    date: releasedAt,
                    color: AppColors.success,
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 14),

            // ── Reference ────────────────────────────────────────────────
            _SectionCard(
              cs: cs,
              title: 'Reference',
              icon: Icons.tag_outlined,
              children: [
                Text(
                  outTradeNo,
                  style: TextStyle(
                    color: cs.textSecondary,
                    fontSize: 12,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(dynamic val) =>
      val != null ? DateTime.tryParse(val as String) : null;

  Color _statusColor(String s) {
    switch (s) {
      case 'HELD':
        return const Color(0xFF2196F3);
      case 'RELEASED':
        return AppColors.success;
      case 'DISPUTED':
        return AppColors.warning;
      case 'REFUNDED':
        return AppColors.grey;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case 'HELD':
        return Icons.lock_outline;
      case 'RELEASED':
        return Icons.check_circle_outline;
      case 'DISPUTED':
        return Icons.flag_outlined;
      case 'REFUNDED':
        return Icons.undo;
      default:
        return Icons.hourglass_empty;
    }
  }

  String _statusDescription(String s) {
    switch (s) {
      case 'HELD':
        return 'Funds are held in escrow.';
      case 'RELEASED':
        return 'Payment has been released to the carrier.';
      case 'DISPUTED':
        return 'Under admin review.';
      case 'REFUNDED':
        return 'Payment was refunded.';
      default:
        return 'Awaiting payment confirmation.';
    }
  }

  Color _gatewayColor(String g) {
    switch (g) {
      case 'TELEBIRR':
        return const Color(0xFF00A651);
      case 'CBE':
        return const Color(0xFF003087);
      case 'CHAPA':
        return const Color(0xFF1DBF73);
      default:
        return AppColors.grey;
    }
  }

  IconData _gatewayIcon(String g) {
    switch (g) {
      case 'TELEBIRR':
        return Icons.phone_android;
      case 'CBE':
        return Icons.account_balance;
      case 'CHAPA':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  String _gatewayLabel(String g) {
    switch (g) {
      case 'TELEBIRR':
        return 'Telebirr';
      case 'CBE':
        return 'CBE Birr';
      case 'CHAPA':
        return 'Chapa';
      default:
        return g;
    }
  }

  String _gatewaySubtitle(String g) {
    switch (g) {
      case 'TELEBIRR':
        return 'Ethio Telecom Mobile Payment';
      case 'CBE':
        return 'Commercial Bank of Ethiopia';
      case 'CHAPA':
        return 'Chapa Online Payment';
      default:
        return 'Payment Gateway';
    }
  }
}

// ── Section card ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final AppColorScheme cs;
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SectionCard({
    required this.cs,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

// ── Detail row ────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme cs;
  final bool bold;
  final Color? valueColor;
  const _DetailRow({
    required this.label,
    required this.value,
    required this.cs,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: cs.textSecondary, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? cs.textPrimary,
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Timeline row ──────────────────────────────────────────────────────────

class _TimelineRow extends StatelessWidget {
  final String label;
  final DateTime date;
  final Color color;
  final IconData icon;
  const _TimelineRow({
    required this.label,
    required this.date,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          DateFormat('MMM d, y · HH:mm').format(date),
          style: const TextStyle(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class _TimelineDivider extends StatelessWidget {
  final AppColorScheme cs;
  const _TimelineDivider({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
      child: Container(width: 2, height: 16, color: cs.border),
    );
  }
}
