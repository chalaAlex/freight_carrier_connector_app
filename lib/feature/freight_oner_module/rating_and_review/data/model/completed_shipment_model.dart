import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/entity/review_entity.dart';

class CompletedShipmentModel {
  final String id;
  final String carrierId;
  final String? carrierBrand;
  final String? carrierModel;
  final String? plateNumber;
  final String status;
  final bool isReviewed;
  final DateTime createdAt;

  CompletedShipmentModel({
    required this.id,
    required this.carrierId,
    this.carrierBrand,
    this.carrierModel,
    this.plateNumber,
    required this.status,
    required this.isReviewed,
    required this.createdAt,
  });

  factory CompletedShipmentModel.fromJson(Map<String, dynamic> json) {
    final carrier = json['carrierId'] as Map<String, dynamic>?;
    return CompletedShipmentModel(
      id: json['_id'] as String,
      carrierId: carrier?['_id'] as String? ?? '',
      carrierBrand: carrier?['brand'] as String?,
      carrierModel: carrier?['model'] as String?,
      plateNumber: carrier?['plateNumber'] as String?,
      status: json['status'] as String,
      isReviewed: json['isReviewed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  CompletedShipmentEntity toEntity() {
    return CompletedShipmentEntity(
      id: id,
      carrierId: carrierId,
      carrierBrand: carrierBrand,
      carrierModel: carrierModel,
      plateNumber: plateNumber,
      status: status,
      isReviewed: isReviewed,
      createdAt: createdAt,
    );
  }
}
