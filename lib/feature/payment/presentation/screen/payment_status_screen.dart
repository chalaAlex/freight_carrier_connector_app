import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_event.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PaymentStatusScreen extends StatefulWidget {
  final String paymentId;
  const PaymentStatusScreen({super.key, required this.paymentId});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(GetPaymentStatusEvent(widget.paymentId));
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
          'Payment Status',
          style: TextStyle(
            color: cs.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: cs.textPrimary),
            onPressed: () => context.read<PaymentBloc>().add(
              GetPaymentStatusEvent(widget.paymentId),
            ),
          ),
        ],
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentReleased) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment released successfully!'),
                backgroundColor: Color(0xFF22C55E),
              ),
            );
            context.read<PaymentBloc>().add(
              GetPaymentStatusEvent(widget.paymentId),
            );
          } else if (state is PaymentDisputed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dispute raised. Admin will review.'),
                backgroundColor: Color(0xFFFACC15),
              ),
            );
            context.read<PaymentBloc>().add(
              GetPaymentStatusEvent(widget.paymentId),
            );
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PaymentStatusLoaded) {
            return _PaymentStatusBody(payment: state.payment, cs: cs);
          }
          if (state is PaymentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: cs.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<PaymentBloc>().add(
                      GetPaymentStatusEvent(widget.paymentId),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PaymentStatusBody extends StatelessWidget {
  final PaymentEntity payment;
  final AppColorScheme cs;
  const _PaymentStatusBody({required this.payment, required this.cs});

  @override
  Widget build(BuildContext context) {
    final status = payment.status ?? 'PENDING';
    final statusInfo = _statusInfo(status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Status hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: statusInfo.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: statusInfo.color.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(statusInfo.icon, size: 56, color: statusInfo.color),
                const SizedBox(height: 12),
                Text(
                  statusInfo.label,
                  style: TextStyle(
                    color: statusInfo.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusInfo.description,
                  style: TextStyle(color: cs.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Amount breakdown
          _InfoCard(
            cs: cs,
            title: 'Payment Details',
            rows: [
              _InfoRow(
                'Total Amount',
                'ETB ${payment.totalAmount?.toStringAsFixed(2) ?? "—"}',
              ),
              _InfoRow(
                'Platform Fee',
                'ETB ${payment.platformFee?.toStringAsFixed(2) ?? "—"}',
              ),
              _InfoRow(
                'Carrier Amount',
                'ETB ${payment.carrierAmount?.toStringAsFixed(2) ?? "—"}',
              ),
              if (payment.paidAt != null)
                _InfoRow(
                  'Paid At',
                  DateFormat('MMM d, y HH:mm').format(payment.paidAt!),
                ),
              if (payment.releaseAt != null && status == 'HELD')
                _InfoRow(
                  'Auto-release At',
                  DateFormat('MMM d, y HH:mm').format(payment.releaseAt!),
                ),
              if (payment.releasedAt != null)
                _InfoRow(
                  'Released At',
                  DateFormat('MMM d, y HH:mm').format(payment.releasedAt!),
                ),
            ],
          ),
          const SizedBox(height: 20),
          // Dev-only: simulate Telebirr payment confirmation
          if (status == 'PENDING')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DEV MODE',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Telebirr is mocked. Tap below to simulate a successful payment callback.',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _simulatePayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Simulate Telebirr Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Actions for HELD status
          if (status == 'HELD') ...[
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _confirmRelease(context),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'Release Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _confirmDispute(context),
                icon: Icon(Icons.flag_outlined, color: AppColors.error),
                label: Text(
                  'Raise Dispute',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmRelease(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Release Payment'),
        content: const Text(
          'Are you sure you want to release the payment to the carrier? This confirms the shipment is complete.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PaymentBloc>().add(ReleasePaymentEvent(payment.id!));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Release', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDispute(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Raise Dispute'),
        content: const Text(
          'This will pause the auto-release and flag the payment for admin review. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PaymentBloc>().add(DisputePaymentEvent(payment.id!));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(
              'Raise Dispute',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// DEV ONLY — simulates a Telebirr webhook callback so we can test the
  /// PENDING → HELD transition without a real Telebirr integration.
  Future<void> _simulatePayment(BuildContext context) async {
    final outTradeNo = payment.outTradeNo;
    if (outTradeNo == null) return;

    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/v1'));
      await dio.post('/payments/mock-confirm/$outTradeNo');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Simulated payment sent — refreshing status...'),
            backgroundColor: Colors.orange,
          ),
        );
        context.read<PaymentBloc>().add(GetPaymentStatusEvent(payment.id!));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Simulation failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  _StatusInfo _statusInfo(String status) {
    switch (status) {
      case 'HELD':
        return _StatusInfo(
          Icons.lock_outline,
          AppColors.primary,
          'Funds Held in Escrow',
          'Payment received. Funds will be released when you confirm delivery.',
        );
      case 'RELEASED':
        return _StatusInfo(
          Icons.check_circle_outline,
          AppColors.success,
          'Payment Released',
          'Funds have been credited to the carrier\'s wallet.',
        );
      case 'DISPUTED':
        return _StatusInfo(
          Icons.flag_outlined,
          AppColors.warning,
          'Under Dispute',
          'An admin is reviewing this payment.',
        );
      case 'REFUNDED':
        return _StatusInfo(
          Icons.undo,
          AppColors.grey,
          'Refunded',
          'Payment has been refunded.',
        );
      default:
        return _StatusInfo(
          Icons.hourglass_empty,
          AppColors.grey,
          'Pending',
          'Waiting for Telebirr confirmation.',
        );
    }
  }
}

class _StatusInfo {
  final IconData icon;
  final Color color;
  final String label;
  final String description;
  const _StatusInfo(this.icon, this.color, this.label, this.description);
}

class _InfoCard extends StatelessWidget {
  final AppColorScheme cs;
  final String title;
  final List<_InfoRow> rows;
  const _InfoCard({required this.cs, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: cs.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r.label,
                    style: TextStyle(color: cs.textSecondary, fontSize: 13),
                  ),
                  Text(
                    r.value,
                    style: TextStyle(
                      color: cs.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
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

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
}
