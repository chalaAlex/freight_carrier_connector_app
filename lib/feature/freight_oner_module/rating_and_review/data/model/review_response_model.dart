import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/entity/review_entity.dart';

class ReviewResponseModel {
  final String id;
  final String reviewerId;
  final String shipmentRequestId;
  final String targetId;
  final String targetType;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  ReviewResponseModel({
    required this.id,
    required this.reviewerId,
    required this.shipmentRequestId,
    required this.targetId,
    required this.targetType,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      id: json['_id'] as String,
      reviewerId: json['reviewerId'] is Map
          ? (json['reviewerId'] as Map)['_id'] as String
          : json['reviewerId'] as String,
      shipmentRequestId: json['shipmentRequestId'] as String,
      targetId: json['targetId'] as String,
      targetType: json['targetType'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      reviewerId: reviewerId,
      shipmentRequestId: shipmentRequestId,
      targetId: targetId,
      targetType: targetType,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
    );
  }
}
