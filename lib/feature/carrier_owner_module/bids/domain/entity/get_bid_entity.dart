import 'package:equatable/equatable.dart';

class GetBidFreightOwnerEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final double? ratingAverage;
  final int? ratingQuantity;

  const GetBidFreightOwnerEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.ratingAverage,
    this.ratingQuantity,
  });

  String get fullName =>
      [firstName, lastName].where((s) => s != null && s.isNotEmpty).join(' ');

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    profileImage,
    ratingAverage,
    ratingQuantity,
  ];
}

class GetBidDetailEntity extends Equatable {
  final String? id;
  final GetBidFreightOwnerEntity? freightOwner;
  final String? carrierOwnerId;
  final String? carrierId;
  final String? freightId;
  final double? bidAmount;
  final String? message;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GetBidDetailEntity({
    this.id,
    this.freightOwner,
    this.carrierOwnerId,
    this.carrierId,
    this.freightId,
    this.bidAmount,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    freightOwner,
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

class GetBidResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final GetBidDetailEntity? bid;

  const GetBidResponseEntity({this.statusCode, this.message, this.bid});

  @override
  List<Object?> get props => [statusCode, message, bid];
}
