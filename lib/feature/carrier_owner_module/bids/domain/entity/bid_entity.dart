import 'package:equatable/equatable.dart';

class BidEntity extends Equatable {
  final String id;
  final String freightOwnerId;
  final String carrierOwnerId;
  final String carrierId;
  final String freightId;
  final double bidAmount;
  final String message;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BidEntity({
    required this.id,
    required this.freightOwnerId,
    required this.carrierOwnerId,
    required this.carrierId,
    required this.freightId,
    required this.bidAmount,
    required this.message,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    freightOwnerId,
    carrierOwnerId,
    carrierId,
    freightId,
    bidAmount,
    message,
    status,
    createdAt,
    updatedAt,
  ];
}

class CreateBidResponseEntity extends Equatable {
  final int statusCode;
  final String message;
  final BidEntity? bid;

  const CreateBidResponseEntity({
    required this.statusCode,
    required this.message,
    this.bid,
  });

  @override
  List<Object?> get props => [statusCode, message, bid];
}
