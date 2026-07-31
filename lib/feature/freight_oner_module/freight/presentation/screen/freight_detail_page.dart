import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/freight_detail_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/freight/freight_state.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/widgets/truck_detail/truck_detail_loading.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_event.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/payment/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FreightDetailPage extends StatefulWidget {
  final String freightId;
  const FreightDetailPage({super.key, required this.freightId});

  @override
  State<FreightDetailPage> createState() => _FreightDetailPageState();
}

class _FreightDetailPageState extends State<FreightDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<FreightBloc>().add(FetchFreightDetailEvent(widget.freightId));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocBuilder<FreightBloc, FreightState>(
      builder: (context, freightState) {
        final freight = freightState is FreightDetailSuccess
            ? freightState.response.freight
            : null;
        final isInTransit = freight?.status.toUpperCase() == 'IN_TRANSIT';

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            elevation: 0,
            leading: BackButton(color: colors.textPrimary),
            title: Text('Freight Details', style: context.text.titleLarge),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: colors.textPrimary),
                onSelected: (value) {
                  if (value == 'complete' && freight != null) {
                    _confirmComplete(context, freight.id);
                  }
                },
                itemBuilder: (_) => isInTransit
                    ? [
                        const PopupMenuItem(
                          value: 'complete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: AppColors.success,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text('Mark as Completed'),
                            ],
                          ),
                        ),
                      ]
                    : [
                        const PopupMenuItem(
                          enabled: false,
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.grey,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'No actions available',
                                style: TextStyle(color: AppColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
              ),
            ],
          ),
          body: Builder(
            builder: (_) {
              if (freightState is FreightLoading) {
                return const Center(child: TruckDetailLoadingWidget());
              }
              if (freightState is FreightError) {
                return Center(
                  child: Text(
                    freightState.message,
                    style: TextStyle(color: colors.error),
                  ),
                );
              }
              if (freightState is FreightDetailSuccess) {
                if (freight == null) {
                  return Center(
                    child: Text(
                      'No data found',
                      style: context.text.bodyMedium,
                    ),
                  );
                }
                return _FreightDetailContent(freight: freight);
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  void _confirmComplete(BuildContext context, String freightId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mark as Completed'),
        content: const Text(
          'This will confirm delivery and automatically release the payment to the carrier\'s wallet. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _releasePaymentForFreight(context, freightId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _releasePaymentForFreight(BuildContext context, String freightId) {
    final paymentBloc = sl<PaymentBloc>();
    paymentBloc.stream.listen((state) {
      if (!mounted) return;
      if (state is PaymentByFreightLoaded) {
        paymentBloc.add(ReleasePaymentEvent(state.payment.id!));
      } else if (state is PaymentReleased) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment released. Freight marked as completed.'),
            backgroundColor: AppColors.success,
          ),
        );
        context.read<FreightBloc>().add(FetchFreightDetailEvent(freightId));
      } else if (state is PaymentError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
    paymentBloc.add(GetPaymentByFreightEvent(freightId));
  }
}

class _FreightDetailContent extends StatelessWidget {
  final FreightDetailEntity freight;
  const _FreightDetailContent({required this.freight});

  String _formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroImage(freight: freight),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RouteCard(freight: freight, formatDate: _formatDate),
                    const SizedBox(height: 12),
                    _CargoSpecsCard(freight: freight),
                    const SizedBox(height: 12),
                    _CargoDescriptionCard(freight: freight),
                    const SizedBox(height: 12),
                    _TruckRequirementsCard(freight: freight),
                    const SizedBox(height: 12),
                    _PayoutCard(freight: freight),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: _RequestButton(freightId: freight.id),
        // ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  final FreightDetailEntity freight;
  const _HeroImage({required this.freight});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return const Color(0xFFFF6B00);
      case 'BIDDING':
        return AppColors.primary;
      case 'BOOKED':
        return const Color(0xFF2196F3);
      case 'IN_TRANSIT':
        return const Color(0xFF9C27B0);
      case 'COMPLETED':
        return AppColors.success;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final statusColor = _statusColor(freight.status);
    return Stack(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: freight.image.isNotEmpty
              ? Image.network(freight.image.first, fit: BoxFit.cover)
              : Container(
                  color: colors.surface,
                  child: Icon(
                    Icons.local_shipping,
                    size: 64,
                    color: colors.textSecondary,
                  ),
                ),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LOAD ID', style: context.text.labelMedium),
                Text(
                  '#${freight.id.substring(0, 14)}',
                  style: context.text.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              freight.status.toUpperCase().replaceAll('_', ' '),
              style: context.text.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  final FreightDetailEntity freight;
  final String Function(DateTime) formatDate;
  const _RouteCard({required this.freight, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final pickup = freight.route.pickup;
    final dropoff = freight.route.dropoff;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROUTE DETAILS',
            style: context.text.labelMedium?.copyWith(letterSpacing: 1),
          ),
          const SizedBox(height: 16),
          _RouteStop(
            label: 'Pickup',
            labelColor: colors.primary,
            dotColor: colors.primary,
            location: '${pickup.city}, ${pickup.region}',
            date: formatDate(freight.schedule.pickupDate),
            datePrefix: '',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Container(width: 2, height: 20, color: colors.border),
          ),
          _RouteStop(
            label: 'Dropoff',
            labelColor: const Color(0xFFFF8C42),
            dotColor: const Color(0xFFFF8C42),
            location: '${dropoff.city}, ${dropoff.region}',
            date: formatDate(freight.schedule.deliveryDeadline),
            datePrefix: 'By ',
          ),
        ],
      ),
    );
  }
}

class _RouteStop extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color dotColor;
  final String location;
  final String date;
  final String datePrefix;
  const _RouteStop({
    required this.label,
    required this.labelColor,
    required this.dotColor,
    required this.location,
    required this.date,
    required this.datePrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CircleAvatar(radius: 5, backgroundColor: dotColor),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.text.labelLarge?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(location, style: context.text.titleMedium),
            Text('$datePrefix$date', style: context.text.labelMedium),
          ],
        ),
      ],
    );
  }
}

class _CargoSpecsCard extends StatelessWidget {
  final FreightDetailEntity freight;
  const _CargoSpecsCard({required this.freight});

  @override
  Widget build(BuildContext context) {
    final cargo = freight.cargo;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.inventory_2_outlined,
            title: 'Cargo Specifications',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LabelValue(label: 'Type', value: cargo.type!),
              const SizedBox(width: 32),
              _LabelValue(label: 'Quantity', value: '${cargo.quantity} units'),
            ],
          ),
          const SizedBox(height: 10),
          _LabelValue(label: 'Weight', value: '${cargo.weightKg} kg'),
        ],
      ),
    );
  }
}

class _CargoDescriptionCard extends StatelessWidget {
  final FreightDetailEntity freight;
  const _CargoDescriptionCard({required this.freight});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.description_outlined,
            title: 'Cargo Description',
          ),
          const SizedBox(height: 12),
          Text('Description', style: context.text.labelMedium),
          const SizedBox(height: 4),
          Text(
            '"${freight.cargo.description}"',
            style: context.text.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _TruckRequirementsCard extends StatelessWidget {
  final FreightDetailEntity freight;
  const _TruckRequirementsCard({required this.freight});

  String _formatNumber(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );

  @override
  Widget build(BuildContext context) {
    final truck = freight.truckRequirement;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.local_shipping_outlined,
            title: 'Truck Requirements',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LabelValue(
                label: 'Truck Type',
                value: truck.type?.join(', ') ?? 'N/A',
              ),
              const SizedBox(width: 32),
              _LabelValue(
                label: 'Min Capacity',
                value: truck.minCapacityKg != null
                    ? '${_formatNumber(truck.minCapacityKg!)} kg'
                    : 'N/A',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayoutCard extends StatelessWidget {
  final FreightDetailEntity freight;
  const _PayoutCard({required this.freight});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final pricing = freight.pricing;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payout',
                style: context.text.labelMedium?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pricing.amount != null ? '${pricing.amount}' : 'Negotiable',
                style: context.text.headlineMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              pricing.type.toUpperCase().replaceAll('_', ' '),
              style: context.text.labelLarge?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _RequestButton extends StatelessWidget {
//   final String freightId;
//   const _RequestButton({required this.freightId});

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.appColors;
//     return Container(
//       color: colors.background,
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//       child: SizedBox(
//         width: double.infinity,
//         height: 52,
//         child: ElevatedButton(
//           onPressed: () {
//             // TODO: navigate to bid/request flow with freightId
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: colors.primary,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Request This Load',
//                 style: context.text.titleMedium?.copyWith(
//                   color: colors.onPrimary,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Icon(Icons.arrow_forward, color: colors.onPrimary, size: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ── Shared helpers ──────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.labelMedium),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
