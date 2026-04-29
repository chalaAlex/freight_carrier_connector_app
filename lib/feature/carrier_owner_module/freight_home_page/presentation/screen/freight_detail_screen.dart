import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/screen/place_bid_screen.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freights_entity.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_or_create_room_usecase.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/chat_room_screen.dart';
import 'package:flutter/material.dart';

class FreightDetailScreen extends StatelessWidget {
  final FreightEntity freight;

  const FreightDetailScreen({super.key, required this.freight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0FA),
      body: CustomScrollView(
        slivers: [
          _FreightSliverAppBar(freight: freight),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                20,
                16,
                MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PricingHeader(freight: freight),
                  const SizedBox(height: 16),
                  _CargoSection(freight: freight),
                  const SizedBox(height: 16),
                  _ScheduleAndVehicleSection(freight: freight),
                  const SizedBox(height: 16),
                  _RouteSection(freight: freight),
                  const SizedBox(height: 16),
                  _AvailableDatesSection(freight: freight),
                  const SizedBox(height: 24),
                  _BottomActionBar(freight: freight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sliver App Bar ───────────────────────────────────────────────────────────

class _FreightSliverAppBar extends StatelessWidget {
  final FreightEntity freight;
  const _FreightSliverAppBar({required this.freight});

  @override
  Widget build(BuildContext context) {
    final hasImage = freight.images != null && freight.images!.isNotEmpty;
    final isAvailable = freight.isAvailable ?? false;

    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A2E),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            hasImage
                ? Image.network(
                    freight.images!.first,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _BannerPlaceholder(),
                  )
                : const _BannerPlaceholder(),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _StatusBadge(isAvailable: isAvailable),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: const Center(
        child: Icon(
          Icons.local_shipping_outlined,
          size: 64,
          color: Colors.white24,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAvailable;
  const _StatusBadge({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.success : AppColors.warning,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAvailable ? 'BOOKED' : 'UNAVAILABLE',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ─── Pricing Header ───────────────────────────────────────────────────────────

class _PricingHeader extends StatelessWidget {
  final FreightEntity freight;
  const _PricingHeader({required this.freight});

  @override
  Widget build(BuildContext context) {
    final amount = freight.pricing?.amount;
    final amountLabel = amount != null ? _formatAmount(amount) : '—';
    final pricingType =
        freight.pricing?.type?.toUpperCase().replaceAll('_', ' ') ?? '—';
    final rawId = freight.id ?? '';
    final freightId =
        '#FR-${rawId.substring(rawId.length > 6 ? rawId.length - 6 : 0).toUpperCase()}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pricingType,
                style: context.text.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
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
                  freightId,
                  style: context.text.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: amountLabel,
                      style: context.text.headlineMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                      ),
                    ),
                    TextSpan(
                      text: '  ETB',
                      style: context.text.titleMedium?.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.gavel_outlined,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${freight.bidCount ?? 0} Bids',
                        style: context.text.bodySmall?.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Available',
                    style: context.text.labelMedium?.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Cargo Section ────────────────────────────────────────────────────────────

class _CargoSection extends StatelessWidget {
  final FreightEntity freight;
  const _CargoSection({required this.freight});

  @override
  Widget build(BuildContext context) {
    final cargo = freight.cargo;
    final cargoType = cargo?.type?.toUpperCase() ?? '—';
    final description = cargo?.description ?? '—';
    final weight = cargo?.weightKg != null
        ? '${cargo!.weightKg!.toStringAsFixed(0)} kg'
        : '—';
    final quantity = cargo?.quantity != null ? '${cargo!.quantity} units' : '—';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CARGO TYPE: $cargoType',
            style: context.text.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: context.text.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'WEIGHT',
                  value: weight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoTile(
                  icon: Icons.category_outlined,
                  label: 'QUANTITY',
                  value: quantity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Schedule & Vehicle Section ───────────────────────────────────────────────

class _ScheduleAndVehicleSection extends StatelessWidget {
  final FreightEntity freight;
  const _ScheduleAndVehicleSection({required this.freight});

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _fmt(DateTime? dt) {
    if (dt == null) return '—';
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${_months[dt.month - 1]} ${dt.day}, ${dt.year}\n$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final truck = freight.truckRequirement;
    final truckType = truck?.type?.toUpperCase().replaceAll('_', ' ') ?? '—';
    final minCapacity = truck?.minCapacityKg != null
        ? '${truck!.minCapacityKg!.toStringAsFixed(0)} kg'
        : '—';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(
                  icon: Icons.calendar_month_outlined,
                  label: 'SCHEDULE',
                ),
                const SizedBox(height: 14),
                Text(
                  'PICKUP DATE',
                  style: context.text.labelMedium?.copyWith(
                    color: AppColors.grey,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _fmt(freight.schedule?.pickupDate),
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'DROPOFF DATE',
                  style: context.text.labelMedium?.copyWith(
                    color: AppColors.grey,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _fmt(freight.schedule?.deliveryDeadline),
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(
                  icon: Icons.local_shipping_outlined,
                  label: 'VEHICLE',
                ),
                const SizedBox(height: 14),
                Text(
                  'TRUCK TYPE',
                  style: context.text.labelMedium?.copyWith(
                    color: AppColors.grey,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  truckType,
                  style: context.text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MIN CAPACITY',
                        style: context.text.labelMedium?.copyWith(
                          color: AppColors.primary,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        minCapacity,
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Route Section ────────────────────────────────────────────────────────────

class _RouteSection extends StatelessWidget {
  final FreightEntity freight;
  const _RouteSection({required this.freight});

  @override
  Widget build(BuildContext context) {
    final pickup = freight.route?.pickup;
    final dropoff = freight.route?.dropoff;
    final pickupCity = [
      pickup?.region,
      pickup?.city,
    ].whereType<String>().join(', ');
    final dropoffCity = [
      dropoff?.region,
      dropoff?.city,
    ].whereType<String>().join(', ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROUTE DETAILS',
            style: context.text.labelMedium?.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          // Pickup
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: const Color(0xFFDDDDEE),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PICKUP',
                      style: context.text.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pickupCity.isNotEmpty ? pickupCity : '—',
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (pickup?.address != null)
                      Text(
                        pickup!.address!,
                        style: context.text.bodySmall?.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Dropoff
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flag_outlined,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DROPOFF',
                      style: context.text.labelMedium?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dropoffCity.isNotEmpty ? dropoffCity : '—',
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (dropoff?.address != null)
                      Text(
                        dropoff!.address!,
                        style: context.text.bodySmall?.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Available Dates Section ──────────────────────────────────────────────────

class _AvailableDatesSection extends StatelessWidget {
  final FreightEntity freight;
  const _AvailableDatesSection({required this.freight});

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final pickup = freight.schedule?.pickupDate;
    final deadline = freight.schedule?.deliveryDeadline;

    String dateRange = '—';
    if (pickup != null && deadline != null) {
      dateRange =
          '${_months[pickup.month - 1]} ${pickup.day} – ${pickup.day + (deadline.difference(pickup).inDays)}, ${pickup.year}';
    } else if (pickup != null) {
      dateRange = '${_months[pickup.month - 1]} ${pickup.day}, ${pickup.year}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.date_range_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AVAILABLE DATES',
                style: context.text.labelMedium?.copyWith(
                  color: AppColors.grey,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateRange,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomActionBar extends StatefulWidget {
  final FreightEntity freight;
  const _BottomActionBar({required this.freight});

  @override
  State<_BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<_BottomActionBar> {
  bool _chatLoading = false;

  Future<void> _openChat() async {
    final ownerId = widget.freight.freightOwnerId;
    if (ownerId == null || ownerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Freight owner info not available.')),
      );
      return;
    }

    setState(() => _chatLoading = true);
    final result = await sl<GetOrCreateRoomUseCase>()(ownerId);
    if (!mounted) return;
    setState(() => _chatLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (room) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            roomId: room.id,
            otherParticipantName: 'Freight Owner',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlaceBidScreen(freight: widget.freight),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'PLACE BID',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _chatLoading ? null : _openChat,
                icon: _chatLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: SizedBox.shrink(),
                      )
                    : const Icon(Icons.chat_bubble_outline, size: 16),
                label: const Text('CHAT'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border, size: 16),
                label: const Text('SAVE'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Shared helpers & small widgets ──────────────────────────────────────────

final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ],
);

String _formatAmount(double amount) {
  final str = amount.toStringAsFixed(0);
  final buffer = StringBuffer();
  int count = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0) buffer.write(',');
    buffer.write(str[i]);
    count++;
  }
  return buffer.toString().split('').reversed.join();
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.text.labelMedium?.copyWith(
                  color: AppColors.grey,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
