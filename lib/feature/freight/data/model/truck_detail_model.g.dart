// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TruckDetailBaseResponse _$TruckDetailBaseResponseFromJson(
  Map<String, dynamic> json,
) => TruckDetailBaseResponse(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : TruckData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TruckDetailBaseResponseToJson(
  TruckDetailBaseResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

TruckData _$TruckDataFromJson(Map<String, dynamic> json) => TruckData(
  truck: json['truck'] == null
      ? null
      : TruckDto.fromJson(json['truck'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TruckDataToJson(TruckData instance) => <String, dynamic>{
  'truck': instance.truck,
};

TruckDto _$TruckDtoFromJson(Map<String, dynamic> json) => TruckDto(
  id: json['_id'] as String?,
  truckOwner: json['truckOwner'] == null
      ? null
      : TruckOwnerDto.fromJson(json['truckOwner'] as Map<String, dynamic>),
  model: json['model'] as String?,
  plateNumber: json['plateNumber'] as String?,
  brand: json['brand'] as String?,
  pricePerKm: json['pricePerKm'] as num?,
  loadCapacity: json['loadCapacity'] as num?,
  features: _featuresFromJson(json['features']),
  location: json['location'] as String?,
  radiusKm: json['radiusKm'] as num?,
  image: (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
  aboutTruck: json['aboutTruck'] as String?,
  isAvailable: json['isAvailable'] as bool?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$TruckDtoToJson(TruckDto instance) => <String, dynamic>{
  '_id': instance.id,
  'truckOwner': instance.truckOwner,
  'model': instance.model,
  'plateNumber': instance.plateNumber,
  'brand': instance.brand,
  'pricePerKm': instance.pricePerKm,
  'loadCapacity': instance.loadCapacity,
  'features': instance.features,
  'location': instance.location,
  'radiusKm': instance.radiusKm,
  'image': instance.image,
  'aboutTruck': instance.aboutTruck,
  'isAvailable': instance.isAvailable,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

TruckOwnerDto _$TruckOwnerDtoFromJson(Map<String, dynamic> json) =>
    TruckOwnerDto(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      ratingQuantity: json['ratingQuantity'] as num?,
      ratingAverage: json['ratingAverage'] as num?,
    );

Map<String, dynamic> _$TruckOwnerDtoToJson(TruckOwnerDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'ratingQuantity': instance.ratingQuantity,
      'ratingAverage': instance.ratingAverage,
    };
