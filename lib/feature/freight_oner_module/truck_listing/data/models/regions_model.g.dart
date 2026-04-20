// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionsBaseResponse _$RegionsBaseResponseFromJson(Map<String, dynamic> json) =>
    RegionsBaseResponse(
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : RegionsDataModel.fromJson(json['data'] as Map<String, dynamic>),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RegionsBaseResponseToJson(
  RegionsBaseResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'statusCode': instance.statusCode,
  'total': instance.total,
  'data': instance.data,
};

RegionDto _$RegionDtoFromJson(Map<String, dynamic> json) => RegionDto(
  id: json['_id'] as String,
  name: json['name'] as String,
  country: json['country'] as String,
  isActive: json['isActive'] as bool,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$RegionDtoToJson(RegionDto instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'country': instance.country,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

RegionsDataModel _$RegionsDataModelFromJson(Map<String, dynamic> json) =>
    RegionsDataModel(
      regions: (json['regions'] as List<dynamic>?)
          ?.map((e) => RegionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegionsDataModelToJson(RegionsDataModel instance) =>
    <String, dynamic>{'regions': instance.regions};
