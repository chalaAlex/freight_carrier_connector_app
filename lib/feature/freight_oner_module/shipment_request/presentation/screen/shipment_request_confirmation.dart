import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:flutter/material.dart';

class ShipmentRequestConfirmationScreen extends StatelessWidget {
  final ShipmentRequestEntity shipmentRequest;
  final String carrierName;

  const ShipmentRequestConfirmationScreen({
    super.key,
    required this.shipmentRequest,
    required this.carrierName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    final bookingId = shipmentRequest.id != null
        ? '#${shipmentRequest.id!.substring(shipmentRequest.id!.length > 6 ? shipmentRequest.id!.length - 6 : 0).toUpperCase()}'
        : '—';
    final price = shipmentRequest.proposedPrice;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeManager.s24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Success icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: SizeManager.s24),
              Text(
                'Booking Request Sent!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SizeManager.s12),
              Text(
                "Your request has been successfully sent to the carrier. You'll be notified once they accept or counter your offer.",
                style: TextStyle(fontSize: 14, color: cs.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SizeManager.s32),
              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SizeManager.s16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(SizeManager.r16),
                  border: Border.all(color: cs.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REQUEST SUMMARY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: cs.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: SizeManager.s16),
                    _SummaryRow(label: 'Booking ID', value: bookingId, cs: cs),
                    const SizedBox(height: SizeManager.s12),
                    _SummaryRow(
                      label: 'Carrier',
                      value: carrierName,
                      cs: cs,
                      valueBold: true,
                    ),
                    if (price != null) ...[
                      const SizedBox(height: SizeManager.s12),
                      _SummaryRow(
                        label: 'Offered Price',
                        value: '\$${price.toStringAsFixed(2)}',
                        cs: cs,
                        valueColor: AppColors.primary,
                        valueBold: true,
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(flex: 3),
              // View My Bids button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Pop back to home (pop until first route)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeManager.r12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View My Bids',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: SizeManager.s12),
              // Back to Home button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.textPrimary,
                    side: BorderSide(color: cs.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeManager.r12),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: SizeManager.s24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme cs;
  final bool valueBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.cs,
    this.valueBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: cs.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? cs.textPrimary,
          ),
        ),
      ],
    );
  }
}
