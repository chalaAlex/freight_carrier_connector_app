// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_carrier_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedCarrierBaseResponse _$FeaturedCarrierBaseResponseFromJson(
  Map<String, dynamic> json,
) => FeaturedCarrierBaseResponse(
  status: json['status'] as String,
  results: (json['results'] as num).toInt(),
  data: FeaturedCarrierData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FeaturedCarrierBaseResponseToJson(
  FeaturedCarrierBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'results': instance.results,
  'data': instance.data,
};

FeaturedCarrierData _$FeaturedCarrierDataFromJson(Map<String, dynamic> json) =>
    FeaturedCarrierData(
      featuredCarrier: (json['featuredCarrier'] as List<dynamic>)
          .map((e) => CarrierTruck.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeaturedCarrierDataToJson(
  FeaturedCarrierData instance,
) => <String, dynamic>{'featuredCarrier': instance.featuredCarrier};

CarrierTruck _$CarrierTruckFromJson(Map<String, dynamic> json) => CarrierTruck(
  id: json['_id'] as String,
  truckOwner: json['truckOwner'] as String,
  driver: (json['driver'] as List<dynamic>).map((e) => e as String).toList(),
  company: json['company'] as String,
  model: json['model'] as String,
  plateNumber: json['plateNumber'] as String,
  brand: json['brand'] as String,
  loadCapacity: (json['loadCapacity'] as num).toInt(),
  features: (json['features'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  location: TruckLocation.fromJson(json['location'] as Map<String, dynamic>),
  image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
  aboutTruck: json['aboutTruck'] as String,
  isAvailable: json['isAvailable'] as bool,
  isFeatured: json['isFeatured'] as bool,
  isVerified: json['isVerified'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CarrierTruckToJson(CarrierTruck instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'truckOwner': instance.truckOwner,
      'driver': instance.driver,
      'company': instance.company,
      'model': instance.model,
      'plateNumber': instance.plateNumber,
      'brand': instance.brand,
      'loadCapacity': instance.loadCapacity,
      'features': instance.features,
      'location': instance.location,
      'image': instance.image,
      'aboutTruck': instance.aboutTruck,
      'isAvailable': instance.isAvailable,
      'isFeatured': instance.isFeatured,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

TruckLocation _$TruckLocationFromJson(Map<String, dynamic> json) =>
    TruckLocation(
      startLocation: json['startLocation'] as String,
      destinationLocation: json['destinationLocation'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$TruckLocationToJson(TruckLocation instance) =>
    <String, dynamic>{
      'startLocation': instance.startLocation,
      'destinationLocation': instance.destinationLocation,
      '_id': instance.id,
    };
