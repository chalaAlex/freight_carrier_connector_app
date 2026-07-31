import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_event.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the correct mock checkout UI based on payment.gateway.
class MockCheckoutScreen extends StatelessWidget {
  final PaymentEntity payment;
  const MockCheckoutScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    switch (payment.gateway) {
      case 'cbe':
        return _CbeCheckout(payment: payment);
      case 'chapa':
        return _ChapaCheckout(payment: payment);
      default:
        return _TelebirrCheckout(payment: payment);
    }
  }
}

// ─── Telebirr ────────────────────────────────────────────────────────────────

class _TelebirrCheckout extends StatefulWidget {
  final PaymentEntity payment;
  const _TelebirrCheckout({required this.payment});
  @override
  State<_TelebirrCheckout> createState() => _TelebirrCheckoutState();
}

class _TelebirrCheckoutState extends State<_TelebirrCheckout> {
  final _pinController = TextEditingController();
  static const _brandColor = Color(0xFF00A651);
  static const _bgColor = Color(0xFFF0FAF4);

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _brandColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Telebirr',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Logo area
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _brandColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_android,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ethio Telecom',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'ETB ${widget.payment.totalAmount?.toStringAsFixed(2) ?? "—"}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Smart Truck Platform',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 32),
              // Phone field (read-only display)
              _InputField(
                label: 'Phone Number',
                hint: '+251 9XX XXX XXX',
                icon: Icons.phone,
                accentColor: _brandColor,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // PIN field
              _PinField(controller: _pinController, accentColor: _brandColor),
              const SizedBox(height: 32),
              _PayButton(
                label: 'Pay with Telebirr',
                color: _brandColor,
                outTradeNo: widget.payment.outTradeNo ?? '',
                pinController: _pinController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.foHomePageRoute,
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _brandColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Go to Landing Page',
                    style: TextStyle(
                      color: _brandColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _SecureFooter(color: _brandColor),
            ],
          ),
        ),
      ),
    );
  }

  void _handleState(BuildContext context, PaymentState state) {
    if (state is PaymentConfirmed) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.paymentStatus,
        (r) => r.settings.name == Routes.foHomePageRoute,
        arguments: {'paymentId': state.payment.id},
      );
    } else if (state is PaymentError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

// ─── CBE ─────────────────────────────────────────────────────────────────────

class _CbeCheckout extends StatefulWidget {
  final PaymentEntity payment;
  const _CbeCheckout({required this.payment});
  @override
  State<_CbeCheckout> createState() => _CbeCheckoutState();
}

class _CbeCheckoutState extends State<_CbeCheckout> {
  final _pinController = TextEditingController();
  static const _brandColor = Color(0xFF003087);
  static const _bgColor = Color(0xFFF0F4FA);

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _brandColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'CBE Birr',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _brandColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Commercial Bank of Ethiopia',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'ETB ${widget.payment.totalAmount?.toStringAsFixed(2) ?? "—"}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Smart Truck Platform',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 32),
              _InputField(
                label: 'Account Number',
                hint: '1000XXXXXXXXXX',
                icon: Icons.credit_card,
                accentColor: _brandColor,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _PinField(controller: _pinController, accentColor: _brandColor),
              const SizedBox(height: 32),
              _PayButton(
                label: 'Confirm Transfer',
                color: _brandColor,
                outTradeNo: widget.payment.outTradeNo ?? '',
                pinController: _pinController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.foHomePageRoute,
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _brandColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Go to Landing Page',
                    style: TextStyle(
                      color: _brandColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _SecureFooter(color: _brandColor),
            ],
          ),
        ),
      ),
    );
  }

  void _handleState(BuildContext context, PaymentState state) {
    if (state is PaymentConfirmed) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.paymentStatus,
        (r) => r.settings.name == Routes.foHomePageRoute,
        arguments: {'paymentId': state.payment.id},
      );
    } else if (state is PaymentError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

// ─── Chapa ───────────────────────────────────────────────────────────────────

class _ChapaCheckout extends StatefulWidget {
  final PaymentEntity payment;
  const _ChapaCheckout({required this.payment});
  @override
  State<_ChapaCheckout> createState() => _ChapaCheckoutState();
}

class _ChapaCheckoutState extends State<_ChapaCheckout> {
  final _pinController = TextEditingController();
  static const _brandColor = Color(0xFF1DBF73);
  static const _bgColor = Color(0xFFF2FBF6);

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _brandColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Chapa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _brandColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Chapa Payment',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'ETB ${widget.payment.totalAmount?.toStringAsFixed(2) ?? "—"}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Smart Truck Platform',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 32),
              _InputField(
                label: 'Phone / Card Number',
                hint: '+251 9XX XXX XXX',
                icon: Icons.phone_iphone,
                accentColor: _brandColor,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _PinField(controller: _pinController, accentColor: _brandColor),
              const SizedBox(height: 32),
              _PayButton(
                label: 'Complete Payment',
                color: _brandColor,
                outTradeNo: widget.payment.outTradeNo ?? '',
                pinController: _pinController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.foHomePageRoute,
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _brandColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Go to Landing Page',
                    style: TextStyle(
                      color: _brandColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _SecureFooter(color: _brandColor),
            ],
          ),
        ),
      ),
    );
  }

  void _handleState(BuildContext context, PaymentState state) {
    if (state is PaymentConfirmed) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.paymentStatus,
        (r) => r.settings.name == Routes.foHomePageRoute,
        arguments: {'paymentId': state.payment.id},
      );
    } else if (state is PaymentError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

// ─── Shared widgets ──────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color accentColor;
  final TextInputType keyboardType;
  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.accentColor,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: accentColor, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accentColor.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accentColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accentColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PinField extends StatefulWidget {
  final TextEditingController controller;
  final Color accentColor;
  const _PinField({required this.controller, required this.accentColor});
  @override
  State<_PinField> createState() => _PinFieldState();
}

class _PinFieldState extends State<_PinField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PIN',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: InputDecoration(
            hintText: '••••',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: widget.accentColor,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: widget.accentColor.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: widget.accentColor.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.accentColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PayButton extends StatelessWidget {
  final String label;
  final Color color;
  final String outTradeNo;
  final TextEditingController pinController;
  const _PayButton({
    required this.label,
    required this.color,
    required this.outTradeNo,
    required this.pinController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: state is PaymentLoading
                ? null
                : () {
                    if (pinController.text.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your PIN')),
                      );
                      return;
                    }
                    context.read<PaymentBloc>().add(
                      ConfirmPaymentEvent(outTradeNo),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
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
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _SecureFooter extends StatelessWidget {
  final Color color;
  const _SecureFooter({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          'Secured & Encrypted',
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}
