import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String reviewerId;
  final String shipmentRequestId;
  final String targetId;
  final String targetType; // "carrier_owner" | "company"
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.reviewerId,
    required this.shipmentRequestId,
    required this.targetId,
    required this.targetType,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    reviewerId,
    shipmentRequestId,
    targetId,
    targetType,
    rating,
    comment,
    createdAt,
  ];
}

class CompletedShipmentEntity extends Equatable {
  final String id;
  final String carrierId;
  final String? carrierBrand;
  final String? carrierModel;
  final String? plateNumber;
  final String status;
  final bool isReviewed;
  final DateTime createdAt;

  const CompletedShipmentEntity({
    required this.id,
    required this.carrierId,
    this.carrierBrand,
    this.carrierModel,
    this.plateNumber,
    required this.status,
    required this.isReviewed,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    carrierId,
    carrierBrand,
    carrierModel,
    plateNumber,
    status,
    isReviewed,
    createdAt,
  ];
}
