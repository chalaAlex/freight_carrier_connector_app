import 'package:equatable/equatable.dart';

class MyBidEntity extends Equatable {
  final String id;
  final String freightId;
  final double bidAmount;
  final String message;
  final String status;
  final DateTime? createdAt;
  // Populated freight fields
  final String? freightCargoDescription;
  final String? freightCargoType;
  final String? freightPickup;
  final String? freightDropoff;
  final double? freightPricingAmount;
  final String? freightImage;

  const MyBidEntity({
    required this.id,
    required this.freightId,
    required this.bidAmount,
    required this.message,
    required this.status,
    this.createdAt,
    this.freightCargoDescription,
    this.freightCargoType,
    this.freightPickup,
    this.freightDropoff,
    this.freightPricingAmount,
    this.freightImage,
  });

  @override
  List<Object?> get props => [id, freightId, bidAmount, status, createdAt];
}
