import 'package:json_annotation/json_annotation.dart';
part 'truck_model.g.dart';

@JsonSerializable()
class TruckBaseResponse {
  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'statusCode')
  int? statusCode;

  @JsonKey(name: 'total')
  int? total;

  @JsonKey(name: 'data')
  TruckDataModel? data;

  TruckBaseResponse({this.message, this.statusCode, this.data, this.total});

  factory TruckBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$TruckBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TruckBaseResponseToJson(this);
}

@JsonSerializable()
class TruckDto {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'model')
  final String model;

  @JsonKey(name: 'plateNumber')
  final String plateNumber;

  @JsonKey(name: 'brand')
  final String brand;

  @JsonKey(name: 'pricePerKm')
  final num? pricePerKm; // Made optional

  @JsonKey(name: 'loadCapacity')
  final num loadCapacity;

  @JsonKey(name: 'features')
  final List<String> features;

  @JsonKey(name: 'operatingCorrider')
  final Map<String, dynamic>? operatingCorrider; // Added to get location data

  @JsonKey(name: 'radiusKm')
  final num? radiusKm; // Made optional

  @JsonKey(name: 'image')
  final List<String> image;

  @JsonKey(name: 'isAvailable')
  final bool isAvailable;

  @JsonKey(name: 'isVerified')
  final bool? isVerified;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const TruckDto({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.brand,
    this.pricePerKm,
    required this.loadCapacity,
    required this.features,
    this.operatingCorrider,
    this.radiusKm,
    required this.image,
    required this.isAvailable,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  // Helper getter to extract location from operatingCorrider
  String get location {
    if (operatingCorrider != null) {
      final start = operatingCorrider!['startLocation'] ?? '';
      final destination = operatingCorrider!['destinationLocation'] ?? '';
      return '$start - $destination';
    }
    return 'Unknown';
  }

  factory TruckDto.fromJson(Map<String, dynamic> json) =>
      _$TruckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TruckDtoToJson(this);
}

@JsonSerializable()
class TruckDataModel {
  @JsonKey(name: 'carrier')
  final List<TruckDto>? trucks;

  TruckDataModel({this.trucks});

  factory TruckDataModel.fromJson(Map<String, dynamic> json) =>
      _$TruckDataModelFromJson(json);
}
