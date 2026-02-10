import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/truck.dart';
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

  @JsonKey(name: 'company')
  final String company;

  @JsonKey(name: 'pricePerDay')
  final num pricePerDay;

  @JsonKey(name: 'pricePerHour')
  final num pricePerHour;

  @JsonKey(name: 'capacityTons')
  final num capacityTons;

  @JsonKey(name: 'type')
  final TruckType type;

  @JsonKey(name: 'location')
  final String location;

  @JsonKey(name: 'radiusKm')
  final num radiusKm;
  @JsonKey(name: 'imageUrl')
  final String imageUrl;

  @JsonKey(name: 'isAvailable')
  final bool isAvailable;

  const TruckDto({
    required this.id,
    required this.model,
    required this.company,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.capacityTons,
    required this.type,
    required this.location,
    required this.radiusKm,
    required this.imageUrl,
    required this.isAvailable,
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