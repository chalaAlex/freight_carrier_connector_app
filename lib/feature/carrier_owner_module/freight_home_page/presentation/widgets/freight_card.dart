import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freights_entity.dart';
import 'package:flutter/material.dart';

class FreightCard extends StatelessWidget {
  final FreightEntity freight;
  final VoidCallback onPlaceBid;

  const FreightCard({
    super.key,
    required this.freight,
    required this.onPlaceBid,
  });

  @override
  Widget build(BuildContext context) {
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
    final pickupDate = freight.schedule?.pickupDate;
    final _months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final dateLabel = pickupDate != null
        ? '${_months[pickupDate.month - 1]} ${pickupDate.day}'
        : '—';
    final weightTons = freight.cargo?.weightKg != null
        ? '${(freight.cargo!.weightKg! / 1000).toStringAsFixed(0)} Tons'
        : '—';
    final amount = freight.pricing?.amount;
    final amountLabel = amount != null ? _formatAmount(amount) : '—';
    final pricingType = freight.pricing?.type?.toUpperCase() ?? '';
    final isAvailable = freight.isAvailable ?? false;
    final cargoType = freight.cargo?.type?.toUpperCase() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image banner with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: freight.images != null && freight.images!.isNotEmpty
                    ? Image.network(
                        freight.images!.first,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _PlaceholderBanner(),
                      )
                    : _PlaceholderBanner(),
              ),
              // Cargo type & status badges
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: [
                    if (cargoType.isNotEmpty) _Badge(label: cargoType),
                    const SizedBox(width: 8),
                    _Badge(
                      label: isAvailable ? 'AVAILABLE' : 'UNAVAILABLE',
                      color: isAvailable
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ],
                ),
              ),
              // Favourite button
              Positioned(top: 12, right: 12, child: _FavouriteButton()),
            ],
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        freight.cargo?.description ?? 'Freight',
                        style: context.text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: context.appColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateLabel,
                            style: context.text.bodySmall?.copyWith(
                              color: context.appColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.gavel_outlined,
                            size: 13,
                            color: context.appColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${freight.bidCount ?? 0} BIDS',
                            style: context.text.bodySmall?.copyWith(
                              color: context.appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: amountLabel,
                            style: context.text.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: ' ETB',
                            style: context.text.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      pricingType,
                      style: context.text.labelSmall?.copyWith(
                        color: context.appColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Divider(height: 1, color: context.appColors.border),
          ),

          // Route + weight + bid button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Route row
                      Row(
                        children: [
                          const _RouteDot(color: AppColors.primary),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              pickupLabel.isNotEmpty ? pickupLabel : '—',
                              style: context.text.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: context.appColors.textSecondary,
                            ),
                          ),
                          const _RouteDot(color: AppColors.warning),
                          const SizedBox(width: 6),
                          Flexible(
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
                      const SizedBox(height: 8),
                      // Weight + date row
                      Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 13,
                            color: context.appColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            weightTons,
                            style: context.text.bodySmall?.copyWith(
                              color: context.appColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: context.appColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateLabel,
                            style: context.text.bodySmall?.copyWith(
                              color: context.appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onPlaceBid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Place Bid',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

class _PlaceholderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      color: const Color(0xFF1A1A2E),
      child: const Icon(
        Icons.local_shipping_outlined,
        size: 48,
        color: Colors.white24,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, this.color = const Color(0xFF2B2B2B)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _FavouriteButton extends StatefulWidget {
  @override
  State<_FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<_FavouriteButton> {
  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFavourite = !_isFavourite),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isFavourite ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: _isFavourite ? Colors.red : AppColors.grey,
        ),
      ),
    );
  }
}

class _RouteDot extends StatelessWidget {
  final Color color;

  const _RouteDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
