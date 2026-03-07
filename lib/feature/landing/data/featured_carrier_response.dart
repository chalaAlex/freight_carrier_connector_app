import 'package:json_annotation/json_annotation.dart';
part 'featured_carrier_response.g.dart';

@JsonSerializable()
class FeaturedCarrierBaseResponse {
  final String status;
  final int results;
  final FeaturedCarrierData data;

  FeaturedCarrierBaseResponse({
    required this.status,
    required this.results,
    required this.data,
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

  final String truckOwner;
  final List<String> driver;
  final String company;

  final String model;
  final String plateNumber;
  final String brand;
  final int loadCapacity;

  final List<String> features;
  final TruckLocation location;

  final List<String> image;

  final String aboutTruck;

  final bool isAvailable;
  final bool isFeatured;
  final bool isVerified;

  final DateTime createdAt;
  final DateTime updatedAt;

  CarrierTruck({
    required this.id,
    required this.truckOwner,
    required this.driver,
    required this.company,
    required this.model,
    required this.plateNumber,
    required this.brand,
    required this.loadCapacity,
    required this.features,
    required this.location,
    required this.image,
    required this.aboutTruck,
    required this.isAvailable,
    required this.isFeatured,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarrierTruck.fromJson(Map<String, dynamic> json) =>
      _$CarrierTruckFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierTruckToJson(this);
}

@JsonSerializable()
class TruckLocation {
  final String startLocation;
  final String destinationLocation;

  @JsonKey(name: "_id")
  final String id;

  TruckLocation({
    required this.startLocation,
    required this.destinationLocation,
    required this.id,
  });

  factory TruckLocation.fromJson(Map<String, dynamic> json) =>
      _$TruckLocationFromJson(json);

  Map<String, dynamic> toJson() => _$TruckLocationToJson(this);
}
