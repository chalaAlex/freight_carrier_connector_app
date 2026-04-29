import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_event.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentInitiateScreen extends StatelessWidget {
  final String bookingType;
  final String sourceId;
  final double totalAmount;
  final String freightRoute;

  const PaymentInitiateScreen({
    super.key,
    required this.bookingType,
    required this.sourceId,
    required this.totalAmount,
    required this.freightRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;
    final platformFee = totalAmount * 0.10;
    final carrierAmount = totalAmount * 0.90;

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
          'Confirm Payment',
          style: TextStyle(
            color: cs.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentInitiated) {
            final toPayUrl = state.data.toPayUrl;
            final paymentId = state.data.payment?.id;
            if (toPayUrl != null && toPayUrl.isNotEmpty) {
              // MOCK mode: toPayUrl is an http URL → open in browser to trigger mock-confirm
              // REAL mode: toPayUrl is a rawRequest string → launch as telebirr:// deep link
              if (toPayUrl.startsWith('http')) {
                launchUrl(
                  Uri.parse(toPayUrl),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                // Telebirr In-App deep link scheme
                final uri = Uri.parse('telebirr://pay?$toPayUrl');
                launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
            Navigator.pushReplacementNamed(
              context,
              Routes.paymentStatus,
              arguments: {'paymentId': paymentId},
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionCard(
                  cs: cs,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shipment',
                        style: TextStyle(
                          color: cs.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        freightRoute,
                        style: TextStyle(
                          color: cs.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bookingType == 'BID'
                            ? 'Accepted Bid'
                            : 'Shipment Request',
                        style: TextStyle(color: cs.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  cs: cs,
                  child: Column(
                    children: [
                      _AmountRow(
                        label: 'Total Amount',
                        value: 'ETB ${totalAmount.toStringAsFixed(2)}',
                        cs: cs,
                        isBold: false,
                      ),
                      const Divider(height: 24),
                      _AmountRow(
                        label: 'Platform Fee (10%)',
                        value: 'ETB ${platformFee.toStringAsFixed(2)}',
                        cs: cs,
                        isBold: false,
                        valueColor: AppColors.error,
                      ),
                      const SizedBox(height: 8),
                      _AmountRow(
                        label: 'Carrier Receives (90%)',
                        value: 'ETB ${carrierAmount.toStringAsFixed(2)}',
                        cs: cs,
                        isBold: false,
                        valueColor: AppColors.success,
                      ),
                      const Divider(height: 24),
                      _AmountRow(
                        label: 'You Pay',
                        value: 'ETB ${totalAmount.toStringAsFixed(2)}',
                        cs: cs,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  cs: cs,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A651).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.phone_android,
                          color: Color(0xFF00A651),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Telebirr',
                            style: TextStyle(
                              color: cs.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Mobile Payment',
                            style: TextStyle(
                              color: cs.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Funds are held in escrow and released to the carrier only after you confirm delivery.',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state is PaymentLoading
                        ? null
                        : () => context.read<PaymentBloc>().add(
                            InitiatePaymentEvent(
                              bookingType: bookingType,
                              sourceId: sourceId,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is PaymentLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Pay with Telebirr',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final AppColorScheme cs;
  final Widget child;
  const _SectionCard({required this.cs, required this.child});

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
      child: child,
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme cs;
  final bool isBold;
  final Color? valueColor;
  const _AmountRow({
    required this.label,
    required this.value,
    required this.cs,
    required this.isBold,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: cs.textSecondary,
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? cs.textPrimary,
            fontSize: isBold ? 17 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
