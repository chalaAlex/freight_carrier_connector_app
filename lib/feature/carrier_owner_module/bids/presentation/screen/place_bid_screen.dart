import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/bid_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/bid_event.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/bid_state.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/my_carriers_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/presentation/bloc/my_carriers_state.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freights_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceBidScreen extends StatelessWidget {
  final FreightEntity freight;

  const PlaceBidScreen({super.key, required this.freight});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BidBloc>()),
        BlocProvider(create: (_) => sl<MyCarriersBloc>()..load()),
      ],
      child: _PlaceBidView(freight: freight),
    );
  }
}

class _PlaceBidView extends StatefulWidget {
  final FreightEntity freight;
  const _PlaceBidView({required this.freight});

  @override
  State<_PlaceBidView> createState() => _PlaceBidViewState();
}

class _PlaceBidViewState extends State<_PlaceBidView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  MyCarrierEntity? _selectedCarrier;

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _openTruckPicker(
    BuildContext context,
    MyCarriersState carriersState,
  ) async {
    if (carriersState is MyCarriersLoading) return;
    if (carriersState is MyCarriersError) {
      context.read<MyCarriersBloc>().load();
      return;
    }
    if (carriersState is! MyCarriersSuccess || carriersState.carriers.isEmpty)
      return;

    final result = await showModalBottomSheet<MyCarrierEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TruckPickerSheet(
        carriers: carriersState.carriers,
        selected: _selectedCarrier,
      ),
    );
    if (result != null) setState(() => _selectedCarrier = result);
  }

  void _submit(BuildContext context) {
    if (_selectedCarrier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a truck first'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    context.read<BidBloc>().add(
      SubmitBid(
        freightId: widget.freight.id ?? '',
        carrierId: _selectedCarrier!.id,
        bidAmount: double.parse(_amountController.text.trim()),
        message: _messageController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final freight = widget.freight;
    final pickup = freight.route?.pickup;
    final dropoff = freight.route?.dropoff;
    final pickupLabel = [
      pickup?.region,
      pickup?.city,
    ].whereType<String>().join(', ');
    final dropoffLabel = [
      dropoff?.region,
      dropoff?.city,
    ].whereType<String>().join(', ');

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Place Bid',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<BidBloc, BidState>(
        listener: (context, state) {
          if (state is BidSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Bid placed successfully!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.of(context).pop(true);
          }
          if (state is BidError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, bidState) {
          final isSubmitting = bidState is BidLoading;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FreightSummaryCard(
                    freight: freight,
                    pickupLabel: pickupLabel,
                    dropoffLabel: dropoffLabel,
                  ),
                  const SizedBox(height: 24),

                  // ── Truck selection ──────────────────────────────────
                  _SectionLabel('Select Your Truck'),
                  const SizedBox(height: 10),
                  BlocBuilder<MyCarriersBloc, MyCarriersState>(
                    builder: (context, carriersState) {
                      return _TruckSelectorTile(
                        selected: _selectedCarrier,
                        carriersState: carriersState,
                        onTap: () => _openTruckPicker(context, carriersState),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Bid amount ───────────────────────────────────────
                  _SectionLabel('Bid Amount (ETB)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    decoration: _inputDecoration(
                      context,
                      hint: 'e.g. 5000',
                      icon: Icons.attach_money_rounded,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final n = double.tryParse(v.trim());
                      if (n == null || n <= 0) return 'Enter a valid amount';
                      return null;
                    },
                  ),
                  if (freight.pricing?.amount != null) ...[
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        'Listed price: ${_fmt(freight.pricing!.amount!)} ETB'
                        ' (${freight.pricing!.type ?? ''})',
                        style: context.text.labelMedium?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // ── Message ──────────────────────────────────────────
                  _SectionLabel('Message to Freight Owner'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText:
                          "Introduce yourself and explain why you're the best fit...",
                      hintStyle: context.text.bodySmall?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.trim().length < 5) {
                        return 'Message must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // ── Submit ───────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary.withValues(
                          alpha: 0.6,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'PLACE BID',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Truck selector tile (tappable field in the form) ────────────────────────

class _TruckSelectorTile extends StatelessWidget {
  final MyCarrierEntity? selected;
  final MyCarriersState carriersState;
  final VoidCallback onTap;

  const _TruckSelectorTile({
    required this.selected,
    required this.carriersState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = carriersState is MyCarriersLoading;
    final isError = carriersState is MyCarriersError;

    Widget content;

    if (isLoading) {
      content = Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading your trucks...',
            style: context.text.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      );
    } else if (isError) {
      content = Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Failed to load trucks. Tap to retry.',
              style: context.text.bodySmall?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      );
    } else if (selected != null) {
      content = Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected!.displayName,
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  [
                    selected!.plateNumber,
                    if (selected!.loadCapacity != null)
                      '${selected!.loadCapacity!.toStringAsFixed(0)} kg',
                  ].whereType<String>().join(' · '),
                  style: context.text.labelMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.swap_horiz_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ],
      );
    } else {
      content = Row(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            color: context.appColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Tap to select a truck',
            style: context.text.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.appColors.textSecondary,
            size: 20,
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected != null
                ? AppColors.primary
                : const Color(0xFFE5E5F0),
            width: selected != null ? 1.5 : 1,
          ),
        ),
        child: content,
      ),
    );
  }
}

// ─── Truck picker bottom sheet ────────────────────────────────────────────────

class _TruckPickerSheet extends StatefulWidget {
  final List<MyCarrierEntity> carriers;
  final MyCarrierEntity? selected;

  const _TruckPickerSheet({required this.carriers, required this.selected});

  @override
  State<_TruckPickerSheet> createState() => _TruckPickerSheetState();
}

class _TruckPickerSheetState extends State<_TruckPickerSheet> {
  late MyCarrierEntity? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDEE),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Truck',
                      style: context.text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${widget.carriers.length} trucks',
                      style: context.text.labelMedium?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: widget.carriers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final carrier = widget.carriers[index];
                    final isSelected = _current?.id == carrier.id;
                    return GestureDetector(
                      onTap: () => setState(() => _current = carrier),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.06)
                              : const Color(0xFFF8F8FC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFE5E5F0),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Thumbnail
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.12)
                                    : const Color(0xFFEEEEF8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  carrier.images != null &&
                                      carrier.images!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        carrier.images!.first,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.local_shipping_outlined,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.grey,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.local_shipping_outlined,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.grey,
                                      size: 22,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    carrier.displayName,
                                    style: context.text.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.primary
                                          : context.appColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    [
                                      carrier.plateNumber,
                                      if (carrier.loadCapacity != null)
                                        '${carrier.loadCapacity!.toStringAsFixed(0)} kg',
                                    ].whereType<String>().join(' · '),
                                    style: context.text.labelMedium?.copyWith(
                                      color: context.appColors.textSecondary,
                                    ),
                                  ),
                                  if (carrier.startLocation != null ||
                                      carrier.destinationLocation != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        [
                                          carrier.startLocation,
                                          carrier.destinationLocation,
                                        ].whereType<String>().join(' → '),
                                        style: context.text.labelMedium
                                            ?.copyWith(
                                              color: context
                                                  .appColors
                                                  .textSecondary,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Radio indicator
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFFCCCCDD),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 13,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Confirm button
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _current == null
                        ? null
                        : () => Navigator.of(context).pop(_current),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primary.withValues(
                        alpha: 0.4,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Confirm Selection',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Freight summary card ─────────────────────────────────────────────────────

class _FreightSummaryCard extends StatelessWidget {
  final FreightEntity freight;
  final String pickupLabel;
  final String dropoffLabel;

  const _FreightSummaryCard({
    required this.freight,
    required this.pickupLabel,
    required this.dropoffLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  freight.cargo?.description ?? 'Freight',
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  freight.cargo?.type?.toUpperCase() ?? '',
                  style: context.text.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _dot(AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  pickupLabel.isNotEmpty ? pickupLabel : '—',
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: context.appColors.textSecondary,
                ),
              ),
              _dot(AppColors.warning),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  dropoffLabel.isNotEmpty ? dropoffLabel : '—',
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 13,
                color: context.appColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                freight.cargo?.weightKg != null
                    ? '${freight.cargo!.weightKg!.toStringAsFixed(0)} kg'
                    : '—',
                style: context.text.bodySmall?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.local_shipping_outlined,
                size: 13,
                color: context.appColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                freight.truckRequirement?.type ?? '—',
                style: context.text.bodySmall?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

InputDecoration _inputDecoration(
  BuildContext context, {
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: context.text.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    ),
    prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}

String _fmt(double amount) {
  final str = amount.toStringAsFixed(0);
  final buf = StringBuffer();
  int c = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    if (c > 0 && c % 3 == 0) buf.write(',');
    buf.write(str[i]);
    c++;
  }
  return buf.toString().split('').reversed.join();
}
