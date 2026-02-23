// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationBaseResponse _$LocationBaseResponseFromJson(
  Map<String, dynamic> json,
) => LocationBaseResponse(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => RegionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LocationBaseResponseToJson(
  LocationBaseResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

RegionDto _$RegionDtoFromJson(Map<String, dynamic> json) => RegionDto(
  id: json['_id'] as String?,
  region: json['region'] as String?,
  city: (json['city'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$RegionDtoToJson(RegionDto instance) => <String, dynamic>{
  '_id': instance.id,
  'region': instance.region,
  'city': instance.city,
};
