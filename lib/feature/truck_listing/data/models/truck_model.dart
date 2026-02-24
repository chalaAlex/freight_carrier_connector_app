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
  final num pricePerKm;

  @JsonKey(name: 'loadCapacity')
  final num loadCapacity;

  @JsonKey(name: 'features')
  final String features;

  @JsonKey(name: 'location')
  final String location;

  @JsonKey(name: 'radiusKm')
  final num radiusKm;

  @JsonKey(name: 'image')
  final List<String> image;

  @JsonKey(name: 'isAvailable')
  final bool isAvailable;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const TruckDto({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.brand,
    required this.pricePerKm,
    required this.loadCapacity,
    required this.features,
    required this.location,
    required this.radiusKm,
    required this.image,
    required this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory TruckDto.fromJson(Map<String, dynamic> json) =>
      _$TruckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TruckDtoToJson(this);
}

@JsonSerializable()
class TruckDataModel {
  @JsonKey(name: 'trucks')
  final List<TruckDto>? trucks;

  TruckDataModel({this.trucks});

  factory TruckDataModel.fromJson(Map<String, dynamic> json) =>
      _$TruckDataModelFromJson(json);
}
