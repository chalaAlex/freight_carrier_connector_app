// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TruckBaseResponse _$TruckBaseResponseFromJson(Map<String, dynamic> json) =>
    TruckBaseResponse(
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : TruckDataModel.fromJson(json['data'] as Map<String, dynamic>),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TruckBaseResponseToJson(TruckBaseResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'total': instance.total,
      'data': instance.data,
    };

TruckDto _$TruckDtoFromJson(Map<String, dynamic> json) => TruckDto(
  id: json['_id'] as String,
  model: json['model'] as String,
  plateNumber: json['plateNumber'] as String,
  brand: json['brand'] as String,
  pricePerKm: json['pricePerKm'] as num,
  loadCapacity: json['loadCapacity'] as num,
  features: json['features'] as String,
  location: json['location'] as String,
  radiusKm: json['radiusKm'] as num,
  image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
  isAvailable: json['isAvailable'] as bool,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$TruckDtoToJson(TruckDto instance) => <String, dynamic>{
  '_id': instance.id,
  'model': instance.model,
  'plateNumber': instance.plateNumber,
  'brand': instance.brand,
  'pricePerKm': instance.pricePerKm,
  'loadCapacity': instance.loadCapacity,
  'features': instance.features,
  'location': instance.location,
  'radiusKm': instance.radiusKm,
  'image': instance.image,
  'isAvailable': instance.isAvailable,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

TruckDataModel _$TruckDataModelFromJson(Map<String, dynamic> json) =>
    TruckDataModel(
      trucks: (json['trucks'] as List<dynamic>?)
          ?.map((e) => TruckDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

// ignore: unused_element
Map<String, dynamic> _$TruckDataModelToJson(TruckDataModel instance) =>
    <String, dynamic>{'trucks': instance.trucks};
