import 'package:json_annotation/json_annotation.dart';
part 'freight_response_model.g.dart';

@JsonSerializable()
class FreightBaseResponse {
  @JsonKey(name: 'statusCode')
  final int? statusCode;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final FreightDto? data;

  const FreightBaseResponse({this.statusCode, this.message, this.data});

  factory FreightBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$FreightBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FreightBaseResponseToJson(this);
}

@JsonSerializable()
class FreightDto {
  @JsonKey(name: '_id')
  final String? id;

  final CargoDto? cargo;
  final RouteDto? route;
  final ScheduleDto? schedule;
  final TruckRequirementDto? truckRequirement;
  final PricingDto? pricing;

  final String? status;
  final String? createdAt;

  const FreightDto({
    this.id,
    this.cargo,
    this.route,
    this.schedule,
    this.truckRequirement,
    this.pricing,
    this.status,
    this.createdAt,
  });

  factory FreightDto.fromJson(Map<String, dynamic> json) =>
      _$FreightDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FreightDtoToJson(this);
}

@JsonSerializable()
class CargoDto {
  final String? type;
  final String? description;
  final double? weightKg;
  final int? quantity;

  const CargoDto({this.type, this.description, this.weightKg, this.quantity});

  factory CargoDto.fromJson(Map<String, dynamic> json) =>
      _$CargoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CargoDtoToJson(this);
}

@JsonSerializable()
class RouteDto {
  final LocationDto? pickup;
  final LocationDto? dropoff;

  const RouteDto({this.pickup, this.dropoff});

  factory RouteDto.fromJson(Map<String, dynamic> json) =>
      _$RouteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RouteDtoToJson(this);
}

@JsonSerializable()
class LocationDto {
  final String? region;
  final String? city;
  final String? address;

  const LocationDto({this.city, this.address, this.region});

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}

@JsonSerializable()
class ScheduleDto {
  final String? pickupDate;
  final String? deliveryDeadline;

  const ScheduleDto({this.pickupDate, this.deliveryDeadline});

  factory ScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDtoToJson(this);
}

@JsonSerializable()
class TruckRequirementDto {
  final String? type;
  final double? minCapacityKg;

  const TruckRequirementDto({this.type, this.minCapacityKg});

  factory TruckRequirementDto.fromJson(Map<String, dynamic> json) =>
      _$TruckRequirementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TruckRequirementDtoToJson(this);
}

@JsonSerializable()
class PricingDto {
  final String? type;
  final double? amount;

  const PricingDto({this.type, this.amount});

  factory PricingDto.fromJson(Map<String, dynamic> json) =>
      _$PricingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PricingDtoToJson(this);
}
