import 'package:json_annotation/json_annotation.dart';

part 'truck_detail_model.g.dart';

@JsonSerializable()
class TruckDetailBaseResponse {
  final int? statusCode;
  final String? message;
  final TruckData? data;

  const TruckDetailBaseResponse({this.statusCode, this.message, this.data});

  factory TruckDetailBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$TruckDetailBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TruckDetailBaseResponseToJson(this);
}

@JsonSerializable()
class TruckData {
  final TruckDto? carrier;

  const TruckData({this.carrier});

  factory TruckData.fromJson(Map<String, dynamic> json) =>
      _$TruckDataFromJson(json);

  Map<String, dynamic> toJson() => _$TruckDataToJson(this);
}

@JsonSerializable()
class TruckDto {
  @JsonKey(name: '_id')
  final String? id;

  final TruckOwnerDto? truckOwner;
  @JsonKey(name: 'company', fromJson: _companyFromJson)
  final TruckCompanyDto? company;
  final String? model;
  final String? plateNumber;
  final String? brand;
  final num? pricePerKm;
  final num? loadCapacity;
  @JsonKey(fromJson: _featuresFromJson)
  final List<String>? features;
  final String? location;
  final num? radiusKm;
  final List<String>? image;
  final String? aboutTruck;
  final bool? isAvailable;
  final bool? isItCompaniesCarrier;
  final String? createdAt;
  final String? updatedAt;

  TruckDto({
    this.id,
    this.truckOwner,
    this.company,
    this.model,
    this.plateNumber,
    this.brand,
    this.pricePerKm,
    this.loadCapacity,
    this.features,
    this.location,
    this.radiusKm,
    this.image,
    this.aboutTruck,
    this.isAvailable,
    this.isItCompaniesCarrier,
    this.createdAt,
    this.updatedAt,
  });

  factory TruckDto.fromJson(Map<String, dynamic> json) =>
      _$TruckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TruckDtoToJson(this);
}

@JsonSerializable()
class TruckCompanyDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? legalEntityName;
  final num? ratingAverage;
  final num? ratingQuantity;

  const TruckCompanyDto({
    this.id,
    this.legalEntityName,
    this.ratingAverage,
    this.ratingQuantity,
  });

  factory TruckCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$TruckCompanyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TruckCompanyDtoToJson(this);
}

// Handles company field as either a plain ID string or a populated object
TruckCompanyDto? _companyFromJson(dynamic json) {
  if (json == null) return null;
  if (json is String) return TruckCompanyDto(id: json);
  if (json is Map<String, dynamic>) return TruckCompanyDto.fromJson(json);
  return null;
}

@JsonSerializable()
class TruckOwnerDto {
  @JsonKey(name: '_id')
  final String? id;

  final String? firstName;
  final String? lastName;
  final String? phone;
  final num? ratingQuantity;
  final num? ratingAverage;

  const TruckOwnerDto({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.ratingQuantity,
    this.ratingAverage,
  });

  factory TruckOwnerDto.fromJson(Map<String, dynamic> json) =>
      _$TruckOwnerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TruckOwnerDtoToJson(this);
}

// Helper function to handle features field that can be either String or List
List<String>? _featuresFromJson(dynamic json) {
  if (json == null) return null;

  if (json is List) {
    return json.map((e) => e.toString()).toList();
  }

  if (json is String) {
    // Split by comma and trim whitespace
    return json
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  return null;
}
