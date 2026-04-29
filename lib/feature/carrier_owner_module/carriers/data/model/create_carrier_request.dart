import 'package:json_annotation/json_annotation.dart';

part 'create_carrier_request.g.dart';

@JsonSerializable()
class CarrierDocumentsRequest {
  final String vehicleRegistration;
  final String tradeLicense;
  final String ownerDigitalId;

  const CarrierDocumentsRequest({
    required this.vehicleRegistration,
    required this.tradeLicense,
    required this.ownerDigitalId,
  });

  factory CarrierDocumentsRequest.fromJson(Map<String, dynamic> json) =>
      _$CarrierDocumentsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierDocumentsRequestToJson(this);
}

@JsonSerializable()
class CreateCarrierOperatingCorrider {
  final String startLocation;
  final String destinationLocation;

  const CreateCarrierOperatingCorrider({
    required this.startLocation,
    required this.destinationLocation,
  });

  factory CreateCarrierOperatingCorrider.fromJson(Map<String, dynamic> json) =>
      _$CreateCarrierOperatingCorriderFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCarrierOperatingCorriderToJson(this);
}

@JsonSerializable()
class CreateCarrierRequest {
  final String model;
  final String plateNumber;
  final String brand;
  final double loadCapacity;
  final List<String> features;
  final CreateCarrierOperatingCorrider operatingCorrider;
  final String aboutTruck;
  final CarrierDocumentsRequest documents;
  final List<String> image;

  const CreateCarrierRequest({
    required this.model,
    required this.plateNumber,
    required this.brand,
    required this.loadCapacity,
    required this.features,
    required this.operatingCorrider,
    required this.aboutTruck,
    required this.documents,
    this.image = const [],
  });

  factory CreateCarrierRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCarrierRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCarrierRequestToJson(this);
}
