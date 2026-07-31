import 'package:json_annotation/json_annotation.dart';
part 'featured_carrier_response.g.dart';

@JsonSerializable()
class FeaturedCarrierBaseResponse {
  final int statusCode;
  final int results;
  final String message;
  final FeaturedCarrierData data;

  FeaturedCarrierBaseResponse({
    required this.statusCode,
    required this.results,
    required this.data,
    required this.message,
  });

  factory FeaturedCarrierBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$FeaturedCarrierBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedCarrierBaseResponseToJson(this);
}

@JsonSerializable()
class FeaturedCarrierData {
  final List<CarrierTruck> featuredCarrier;

  FeaturedCarrierData({required this.featuredCarrier});

  factory FeaturedCarrierData.fromJson(Map<String, dynamic> json) =>
      _$FeaturedCarrierDataFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedCarrierDataToJson(this);
}

@JsonSerializable()
class CarrierTruck {
  @JsonKey(name: "_id")
  final String id;

  @JsonKey(fromJson: _truckOwnerFromJson)
  final String? truckOwner;
  final List<String>? driver;
  @JsonKey(fromJson: _companyFromJson)
  final String? company;

  final String? model;
  final String? plateNumber;
  final String? brand;
  final int? loadCapacity;

  final List<String>? features;
  final TruckLocation? operatingCorrider;

  final List<String>? image;

  final String? aboutTruck;

  final bool? isAvailable;
  final bool? isFeatured;
  final bool? isVerified;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CarrierTruck({
    required this.id,
    this.truckOwner,
    this.driver,
    this.company,
    this.model,
    this.plateNumber,
    this.brand,
    this.loadCapacity,
    this.features,
    this.operatingCorrider,
    this.image,
    this.aboutTruck,
    this.isAvailable,
    this.isFeatured,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  static String? _truckOwnerFromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is Map) return json['_id'] as String?;
    return null;
  }

  static String? _companyFromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is Map) return json['_id'] as String?;
    return null;
  }

  factory CarrierTruck.fromJson(Map<String, dynamic> json) =>
      _$CarrierTruckFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierTruckToJson(this);
}

@JsonSerializable()
class TruckLocation {
  final String? startLocation;
  final String? destinationLocation;

  @JsonKey(name: "_id")
  final String? id;

  TruckLocation({this.startLocation, this.destinationLocation, this.id});

  factory TruckLocation.fromJson(Map<String, dynamic> json) =>
      _$TruckLocationFromJson(json);

  Map<String, dynamic> toJson() => _$TruckLocationToJson(this);
}
