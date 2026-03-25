import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart';
import 'package:clean_architecture/feature/my_loads/presentation/bloc/my_loads_bloc.dart';
import 'package:clean_architecture/feature/my_loads/presentation/bloc/my_loads_event.dart';
import 'package:clean_architecture/feature/my_loads/presentation/bloc/my_loads_state.dart';
import 'package:clean_architecture/feature/shipment_request/presentation/bloc/shipment_request_bloc.dart';
import 'package:clean_architecture/feature/shipment_request/presentation/bloc/shipment_request_event.dart';
import 'package:clean_architecture/feature/shipment_request/presentation/bloc/shipment_request_state.dart';
import 'package:clean_architecture/feature/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/shipment_request/presentation/screen/shipment_request_confirmation.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateShipmentRequestScreen extends StatefulWidget {
  final TruckEntity truck;

  const CreateShipmentRequestScreen({super.key, required this.truck});

  @override
  State<CreateShipmentRequestScreen> createState() =>
      _CreateShipmentRequestScreenState();
}

class _CreateShipmentRequestScreenState
    extends State<CreateShipmentRequestScreen> {
  final _priceController = TextEditingController();
  final List<String> _selectedFreightIds = [];
  List<MyLoadsEntity> _selectedFreights = [];

  AppColorScheme get _cs {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColorScheme.dark : AppColorScheme.light;
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _openFreightBottomSheet() {
    context.read<MyLoadsBloc>().add(const FetchMyLoads('OPEN'));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<MyLoadsBloc>(),
        child: _FreightSelectionSheet(
          selectedIds: List.from(_selectedFreightIds),
          onConfirm: (selected, entities) {
            setState(() {
              _selectedFreightIds
                ..clear()
                ..addAll(selected);
              _selectedFreights = entities;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = _cs;
    final truck = widget.truck;

    return BlocListener<ShipmentRequestBloc, ShipmentRequestState>(
      listener: (context, state) {
        if (state is ShipmentRequestSuccess) {
          final request = state.response.data?.shipmentRequest;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ShipmentRequestConfirmationScreen(
                shipmentRequest: request ?? const ShipmentRequestEntity(),
                carrierName: '${truck.brand} ${truck.model}',
              ),
            ),
          );
        } else if (state is ShipmentRequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: _buildBody(cs, truck),
    );
  }

  Widget _buildBody(AppColorScheme cs, TruckEntity truck) {
    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Send Booking Request',
          style: TextStyle(
            color: cs.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SizeManager.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(label: 'SELECTED CARRIER', cs: cs),
            const SizedBox(height: SizeManager.s8),
            _CarrierCard(truck: truck, cs: cs),
            const SizedBox(height: SizeManager.s24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel(label: 'SELECT YOUR FREIGHT', cs: cs),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'ADD NEW',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s8),
            _FreightSelector(
              selectedFreights: _selectedFreights,
              cs: cs,
              onTap: _openFreightBottomSheet,
            ),
            const SizedBox(height: SizeManager.s24),
            _SectionLabel(label: 'OFFER DETAILS', cs: cs),
            const SizedBox(height: SizeManager.s12),
            _OfferDetailsRow(controller: _priceController, cs: cs),
            const SizedBox(height: SizeManager.s24),
            _SectionLabel(label: 'MESSAGE TO CARRIER', cs: cs),
            const SizedBox(height: SizeManager.s8),
            _MessageField(cs: cs),
            const SizedBox(height: SizeManager.s24),
            _TermsText(cs: cs),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<ShipmentRequestBloc, ShipmentRequestState>(
            builder: (context, state) {
              final isLoading = state is ShipmentRequestLoading;
              return _SendButton(
                cs: cs,
                enabled: _selectedFreightIds.isNotEmpty && !isLoading,
                isLoading: isLoading,
                onTap: () {
                  final price = int.tryParse(_priceController.text.trim());
                  context.read<ShipmentRequestBloc>().add(
                    SubmitShipmentRequest(
                      carrierId: truck.id,
                      freightIds: List.from(_selectedFreightIds),
                      proposedPrice: price,
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppColorScheme cs;

  const _SectionLabel({required this.label, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: cs.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Carrier card ──────────────────────────────────────────────────────────

class _CarrierCard extends StatelessWidget {
  final TruckEntity truck;
  final AppColorScheme cs;

  const _CarrierCard({required this.truck, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        border: Border.all(color: cs.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (truck.isVerified == true)
                  Row(
                    children: [
                      Icon(Icons.verified, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        'VERIFIED CARRIER',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warning,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: SizeManager.s4),
                Text(
                  '${truck.brand} ${truck.model}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: SizeManager.s4),
                Text(
                  '${truck.model} • ${truck.loadCapacity.toStringAsFixed(0)} Tons Capacity',
                  style: TextStyle(fontSize: 13, color: cs.textSecondary),
                ),
                const SizedBox(height: SizeManager.s12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    padding: const EdgeInsets.symmetric(
                      horizontal: SizeManager.s16,
                      vertical: SizeManager.s8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeManager.r6),
                    ),
                  ),
                  child: const Text(
                    'View Profile',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: SizeManager.s12),
          ClipRRect(
            borderRadius: BorderRadius.circular(SizeManager.r10),
            child: truck.images.isNotEmpty
                ? Image.network(
                    truck.images.first,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _ImagePlaceholder(cs: cs),
                  )
                : _ImagePlaceholder(cs: cs),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final AppColorScheme cs;
  const _ImagePlaceholder({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      color: cs.border,
      child: Icon(Icons.local_shipping, size: 36, color: cs.textSecondary),
    );
  }
}

// ── Freight selector ──────────────────────────────────────────────────────

class _FreightSelector extends StatelessWidget {
  final List<MyLoadsEntity> selectedFreights;
  final AppColorScheme cs;
  final VoidCallback onTap;

  const _FreightSelector({
    required this.selectedFreights,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeManager.s16,
          vertical: SizeManager.s12,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(SizeManager.r12),
          border: Border.all(color: cs.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedFreights.isEmpty
                  ? Text(
                      'Choose listed freight',
                      style: TextStyle(fontSize: 15, color: cs.textSecondary),
                    )
                  : Text(
                      selectedFreights
                          .map(
                            (f) =>
                                '${f.route?.pickup?.city ?? '?'} → ${f.route?.dropoff?.city ?? '?'}',
                          )
                          .join(', '),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            Icon(Icons.keyboard_arrow_down, color: cs.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ── Offer details row ─────────────────────────────────────────────────────

class _OfferDetailsRow extends StatelessWidget {
  final TextEditingController controller;
  final AppColorScheme cs;

  const _OfferDetailsRow({required this.controller, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Offered Price (\$)',
                style: TextStyle(fontSize: 12, color: cs.textSecondary),
              ),
              const SizedBox(height: SizeManager.s4),
              _InputBox(
                controller: controller,
                hint: '2,500',
                keyboardType: TextInputType.number,
                cs: cs,
              ),
            ],
          ),
        ),
        const SizedBox(width: SizeManager.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pickup Date',
                style: TextStyle(fontSize: 12, color: cs.textSecondary),
              ),
              const SizedBox(height: SizeManager.s4),
              _InputBox(
                controller: null,
                hint: 'mm/dd/yyyy',
                keyboardType: TextInputType.datetime,
                cs: cs,
                suffixIcon: Icons.calendar_today_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final TextInputType keyboardType;
  final AppColorScheme cs;
  final IconData? suffixIcon;

  const _InputBox({
    required this.controller,
    required this.hint,
    required this.keyboardType,
    required this.cs,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r10),
        border: Border.all(color: cs.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 15, color: cs.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: cs.textSecondary),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, size: 18, color: cs.textSecondary)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: SizeManager.s12,
            vertical: SizeManager.s12,
          ),
        ),
      ),
    );
  }
}

// ── Message field ─────────────────────────────────────────────────────────

class _MessageField extends StatelessWidget {
  final AppColorScheme cs;
  const _MessageField({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(SizeManager.r12),
        border: Border.all(color: cs.border),
      ),
      child: TextField(
        maxLines: 4,
        style: TextStyle(fontSize: 14, color: cs.textPrimary),
        decoration: InputDecoration(
          hintText:
              'Add specific instructions, cargo handling requirements, or questions for the driver...',
          hintStyle: TextStyle(fontSize: 13, color: cs.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(SizeManager.s12),
        ),
      ),
    );
  }
}

// ── Terms text ────────────────────────────────────────────────────────────

class _TermsText extends StatelessWidget {
  final AppColorScheme cs;
  const _TermsText({required this.cs});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 12, color: cs.textSecondary),
        children: [
          const TextSpan(text: 'By sending this request, you agree to the '),
          TextSpan(
            text: 'Marketplace Terms of Service',
            style: const TextStyle(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' and booking protocols.'),
        ],
      ),
    );
  }
}

// ── Send button ───────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  final AppColorScheme cs;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _SendButton({
    required this.cs,
    required this.enabled,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SizeManager.s16,
          SizeManager.s8,
          SizeManager.s16,
          SizeManager.s16,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: enabled ? onTap : null,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(Icons.send, size: 18),
            label: Text(
              isLoading ? 'Sending...' : 'Send Booking Request',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Freight selection bottom sheet ────────────────────────────────────────

class _FreightSelectionSheet extends StatefulWidget {
  final List<String> selectedIds;
  final void Function(List<String> ids, List<MyLoadsEntity> entities) onConfirm;

  const _FreightSelectionSheet({
    required this.selectedIds,
    required this.onConfirm,
  });

  @override
  State<_FreightSelectionSheet> createState() => _FreightSelectionSheetState();
}

class _FreightSelectionSheetState extends State<_FreightSelectionSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedIds);
  }

  AppColorScheme get _cs {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColorScheme.dark : AppColorScheme.light;
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = _cs;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(SizeManager.r24),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: SizeManager.s12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SizeManager.s16,
                  SizeManager.s16,
                  SizeManager.s16,
                  SizeManager.s8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Freight Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                    const SizedBox(height: SizeManager.s4),
                    Text(
                      'Select one or more cargo items for this shipment.',
                      style: TextStyle(fontSize: 13, color: cs.textSecondary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(
                child: BlocBuilder<MyLoadsBloc, MyLoadsState>(
                  builder: (context, state) {
                    if (state is MyLoadsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is MyLoadsError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(SizeManager.s24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: cs.error,
                              ),
                              const SizedBox(height: SizeManager.s12),
                              Text(
                                state.message,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: cs.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: SizeManager.s16),
                              TextButton(
                                onPressed: () => context
                                    .read<MyLoadsBloc>()
                                    .add(const FetchMyLoads('OPEN')),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is MyLoadsSuccess) {
                      if (state.freights.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: cs.textSecondary,
                              ),
                              const SizedBox(height: SizeManager.s12),
                              Text(
                                'No open freights available',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: cs.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.all(SizeManager.s16),
                        itemCount: state.freights.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: SizeManager.s12),
                        itemBuilder: (_, i) {
                          final freight = state.freights[i];
                          final id = freight.id ?? '';
                          final isSelected = _selected.contains(id);
                          return _FreightItem(
                            freight: freight,
                            isSelected: isSelected,
                            cs: cs,
                            onTap: () => _toggle(id),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              // Confirm button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(SizeManager.s16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _selected.isEmpty
                          ? null
                          : () {
                              final state = context.read<MyLoadsBloc>().state;
                              final entities = state is MyLoadsSuccess
                                  ? state.freights
                                        .where(
                                          (f) => _selected.contains(f.id ?? ''),
                                        )
                                        .toList()
                                  : <MyLoadsEntity>[];
                              widget.onConfirm(_selected, entities);
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor: AppColors.grey.withValues(
                          alpha: 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeManager.r12),
                        ),
                      ),
                      child: const Text(
                        'Confirm Selection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
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

// ── Freight item ──────────────────────────────────────────────────────────

class _FreightItem extends StatelessWidget {
  final MyLoadsEntity freight;
  final bool isSelected;
  final AppColorScheme cs;
  final VoidCallback onTap;

  const _FreightItem({
    required this.freight,
    required this.isSelected,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pickup = freight.route?.pickup?.city ?? '?';
    final dropoff = freight.route?.dropoff?.city ?? '?';
    final weight = freight.cargo?.weightKg?.toStringAsFixed(1) ?? '—';
    final imageUrl = (freight.images?.isNotEmpty ?? false)
        ? freight.images!.first
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(SizeManager.s12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(SizeManager.r12),
          border: Border.all(
            color: isSelected ? AppColors.warning : cs.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(SizeManager.r10),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _FreightImagePlaceholder(cs: cs),
                    )
                  : _FreightImagePlaceholder(cs: cs),
            ),
            const SizedBox(width: SizeManager.s12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    freight.cargo?.type ?? '—',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SizeManager.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: cs.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$pickup → $dropoff',
                        style: TextStyle(fontSize: 12, color: cs.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.scale_outlined,
                        size: 13,
                        color: cs.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$weight Tons',
                        style: TextStyle(fontSize: 12, color: cs.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.warning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeManager.r4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreightImagePlaceholder extends StatelessWidget {
  final AppColorScheme cs;
  const _FreightImagePlaceholder({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      color: cs.border,
      child: Icon(
        Icons.inventory_2_outlined,
        size: 28,
        color: cs.textSecondary,
      ),
    );
  }
}
