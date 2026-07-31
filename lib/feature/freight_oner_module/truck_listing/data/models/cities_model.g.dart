// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CitiesBaseResponse _$CitiesBaseResponseFromJson(Map<String, dynamic> json) =>
    CitiesBaseResponse(
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : CitiesDataModel.fromJson(json['data'] as Map<String, dynamic>),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CitiesBaseResponseToJson(CitiesBaseResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'total': instance.total,
      'data': instance.data,
    };

CityDto _$CityDtoFromJson(Map<String, dynamic> json) => CityDto(
  id: json['_id'] as String,
  name: json['name'] as String,
  region: json['region'] == null
      ? null
      : RegionRef.fromJson(json['region'] as Map<String, dynamic>),
  isActive: json['isActive'] as bool,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$CityDtoToJson(CityDto instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'region': instance.region,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

RegionRef _$RegionRefFromJson(Map<String, dynamic> json) =>
    RegionRef(id: json['_id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$RegionRefToJson(RegionRef instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
};

CitiesDataModel _$CitiesDataModelFromJson(Map<String, dynamic> json) =>
    CitiesDataModel(
      cities: (json['cities'] as List<dynamic>?)
          ?.map((e) => CityDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CitiesDataModelToJson(CitiesDataModel instance) =>
    <String, dynamic>{'cities': instance.cities};
