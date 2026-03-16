import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart';
import 'package:flutter/material.dart';

enum LoadStatus { open, bidding, booked, completed, cancelled }

class LoadViewModel {
  final String freightId;
  final String pickupCity;
  final String dropoffCity;
  final String truckType;
  final String priceLabel;
  final String priceValue;
  final String statusLabel;
  final Color statusColor;
  final LoadStatus status;
  final String? imageUrl;

  const LoadViewModel({
    required this.freightId,
    required this.pickupCity,
    required this.dropoffCity,
    required this.truckType,
    required this.priceLabel,
    required this.priceValue,
    required this.statusLabel,
    required this.statusColor,
    required this.status,
    this.imageUrl,
  });

  static LoadViewModel from(MyLoadsEntity freight) {
    final status = _parseStatus(freight.status);
    final rawId = freight.id ?? '';
    return LoadViewModel(
      freightId: rawId,
      pickupCity: _cityLabel(freight.route?.pickup),
      dropoffCity: _cityLabel(freight.route?.dropoff),
      truckType: freight.truckRequirement?.type ?? '—',
      priceLabel: _priceLabel(status),
      priceValue: freight.pricing?.amount != null
          ? '\$${freight.pricing!.amount!.toStringAsFixed(0)}'
          : '—',
      statusLabel: _statusLabel(status),
      statusColor: _statusColor(status),
      status: status,
      imageUrl: (freight.images?.isNotEmpty ?? false)
          ? freight.images!.first
          : null,
    );
  }

  static LoadStatus fromStatusString(String? raw) => _parseStatus(raw);

  // ── private helpers ───────────────────────────────────────────────────

  static LoadStatus _parseStatus(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'OPEN':
        return LoadStatus.open;
      case 'BIDDING':
        return LoadStatus.bidding;
      case 'BOOKED':
        return LoadStatus.booked;
      case 'COMPLETED':
        return LoadStatus.completed;
      case 'CANCELLED':
        return LoadStatus.cancelled;
      default:
        return LoadStatus.open;
    }
  }

  static Color _statusColor(LoadStatus s) {
    switch (s) {
      case LoadStatus.open:
        return const Color(0xFFFF6B00);
      case LoadStatus.bidding:
        return AppColors.primary;
      case LoadStatus.booked:
        return const Color(0xFF2196F3);
      case LoadStatus.completed:
        return AppColors.success;
      case LoadStatus.cancelled:
        return AppColors.error;
    }
  }

  static String _statusLabel(LoadStatus s) {
    switch (s) {
      case LoadStatus.open:
        return 'OPEN';
      case LoadStatus.bidding:
        return 'BIDDING';
      case LoadStatus.booked:
        return 'BOOKED';
      case LoadStatus.completed:
        return 'COMPLETED';
      case LoadStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static String _priceLabel(LoadStatus s) {
    switch (s) {
      case LoadStatus.bidding:
        return 'BEST QUOTE';
      case LoadStatus.completed:
      case LoadStatus.booked:
        return 'TOTAL PRICE';
      default:
        return 'PRICE';
    }
  }

  static String _cityLabel(LocationEntity? loc) {
    if (loc == null) return '—';
    final parts = [
      loc.city,
      loc.region,
    ].where((s) => s != null && s.isNotEmpty).join(', ');
    return parts.isNotEmpty ? parts : '—';
  }

  static IconData emptyIcon(LoadStatus s) {
    switch (s) {
      case LoadStatus.open:
        return Icons.local_shipping_outlined;
      case LoadStatus.bidding:
        return Icons.gavel_outlined;
      case LoadStatus.booked:
        return Icons.bookmark_outline;
      case LoadStatus.completed:
        return Icons.check_circle_outline;
      case LoadStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}
