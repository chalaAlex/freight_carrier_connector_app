import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_event.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_state.dart';
import 'package:clean_architecture/feature/payment/presentation/screen/mock_checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentInitiateScreen extends StatefulWidget {
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
  State<PaymentInitiateScreen> createState() => _PaymentInitiateScreenState();
}

class _PaymentInitiateScreenState extends State<PaymentInitiateScreen> {
  String _selectedGateway = 'telebirr';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    // ── New fee model ──────────────────────────────────────────────────────
    // Agreed price  = widget.totalAmount  (what carrier expects)
    // Platform fee  = 10% of agreed price (added ON TOP, paid by freight owner)
    // Freight owner pays = agreed price + platform fee
    // Carrier receives   = agreed price (100% of agreed)
    final agreedPrice = widget.totalAmount;
    final platformFee = agreedPrice * 0.10;
    final youPay = agreedPrice + platformFee;
    final carrierAmount = agreedPrice; // carrier gets full agreed price

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
            final payment = state.data.payment;
            if (payment != null) {
              // Reset bloc state before navigating so back-navigation
              // doesn't re-trigger this listener
              context.read<PaymentBloc>().add(ResetPaymentEvent());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<PaymentBloc>(),
                    child: MockCheckoutScreen(payment: payment),
                  ),
                ),
              );
            }
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
                        widget.freightRoute,
                        style: TextStyle(
                          color: cs.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.bookingType == 'BID'
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
                        label: 'Agreed Price',
                        value: 'ETB ${agreedPrice.toStringAsFixed(2)}',
                        cs: cs,
                      ),
                      const Divider(height: 24),
                      _AmountRow(
                        label: 'Platform Fee (10%)',
                        value: '+ ETB ${platformFee.toStringAsFixed(2)}',
                        cs: cs,
                        valueColor: AppColors.error,
                      ),
                      const SizedBox(height: 8),
                      _AmountRow(
                        label: 'Carrier Receives',
                        value: 'ETB ${carrierAmount.toStringAsFixed(2)}',
                        cs: cs,
                        valueColor: AppColors.success,
                      ),
                      const Divider(height: 24),
                      _AmountRow(
                        label: 'You Pay',
                        value: 'ETB ${youPay.toStringAsFixed(2)}',
                        cs: cs,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Payment Method',
                  style: TextStyle(
                    color: cs.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                ..._gateways.map(
                  (g) => _GatewayTile(
                    gateway: g,
                    isSelected: _selectedGateway == g.id,
                    cs: cs,
                    onTap: () => setState(() => _selectedGateway = g.id),
                  ),
                ),
                const SizedBox(height: 16),
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
                              bookingType: widget.bookingType,
                              sourceId: widget.sourceId,
                              gateway: _selectedGateway,
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
                        : Text(
                            'Continue to ${_gateways.firstWhere((g) => g.id == _selectedGateway).name}',
                            style: const TextStyle(
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

// ─── Gateway definitions ─────────────────────────────────────────────────────

class _GatewayDef {
  final String id;
  final String name;
  final Color brandColor;
  final IconData icon;
  final String subtitle;
  const _GatewayDef({
    required this.id,
    required this.name,
    required this.brandColor,
    required this.icon,
    required this.subtitle,
  });
}

const _gateways = [
  _GatewayDef(
    id: 'telebirr',
    name: 'Telebirr',
    brandColor: Color(0xFF00A651),
    icon: Icons.phone_android,
    subtitle: 'Ethio Telecom Mobile Payment',
  ),
  _GatewayDef(
    id: 'cbe',
    name: 'CBE',
    brandColor: Color(0xFF003087),
    icon: Icons.account_balance,
    subtitle: 'Commercial Bank of Ethiopia',
  ),
  _GatewayDef(
    id: 'chapa',
    name: 'Chapa',
    brandColor: Color(0xFF1DBF73),
    icon: Icons.credit_card,
    subtitle: 'Chapa Online Payment',
  ),
];

class _GatewayTile extends StatelessWidget {
  final _GatewayDef gateway;
  final bool isSelected;
  final AppColorScheme cs;
  final VoidCallback onTap;
  const _GatewayTile({
    required this.gateway,
    required this.isSelected,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? gateway.brandColor : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: gateway.brandColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(gateway.icon, color: gateway.brandColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gateway.name,
                    style: TextStyle(
                      color: cs.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    gateway.subtitle,
                    style: TextStyle(color: cs.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: gateway.brandColor,
                      size: 22,
                      key: const ValueKey('checked'),
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: AppColors.grey,
                      size: 22,
                      key: const ValueKey('unchecked'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared helpers ──────────────────────────────────────────────────────────

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
    this.isBold = false,
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
