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
  company: json['company'] as String,
  pricePerDay: json['pricePerDay'] as num,
  pricePerHour: json['pricePerHour'] as num,
  capacityTons: json['capacityTons'] as num,
  type: $enumDecode(_$TruckTypeEnumMap, json['type']),
  location: json['location'] as String,
  radiusKm: json['radiusKm'] as num,
  imageUrl: json['imageUrl'] as String,
  isAvailable: json['isAvailable'] as bool,
);

Map<String, dynamic> _$TruckDtoToJson(TruckDto instance) => <String, dynamic>{
  '_id': instance.id,
  'model': instance.model,
  'company': instance.company,
  'pricePerDay': instance.pricePerDay,
  'pricePerHour': instance.pricePerHour,
  'capacityTons': instance.capacityTons,
  'type': _$TruckTypeEnumMap[instance.type]!,
  'location': instance.location,
  'radiusKm': instance.radiusKm,
  'imageUrl': instance.imageUrl,
  'isAvailable': instance.isAvailable,
};

const _$TruckTypeEnumMap = {
  TruckType.flatbed: 'flatbed',
  TruckType.refrigerated: 'refrigerated',
  TruckType.dryVan: 'dryVan',
};

TruckDataModel _$TruckDataModelFromJson(Map<String, dynamic> json) =>
    TruckDataModel(
      trucks: (json['trucks'] as List<dynamic>?)
          ?.map((e) => TruckDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

