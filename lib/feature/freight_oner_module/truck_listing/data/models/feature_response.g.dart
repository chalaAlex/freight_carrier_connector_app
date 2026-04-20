// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureBaseResponse _$FeatureBaseResponseFromJson(Map<String, dynamic> json) =>
    FeatureBaseResponse(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      total: (json['total'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : FeatureData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeatureBaseResponseToJson(
  FeatureBaseResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'total': instance.total,
  'data': instance.data,
};

FeatureData _$FeatureDataFromJson(Map<String, dynamic> json) => FeatureData(
  features: (json['features'] as List<dynamic>?)
      ?.map((e) => Feature.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FeatureDataToJson(FeatureData instance) =>
    <String, dynamic>{'features': instance.features};

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  icon: json['icon'] as String?,
  description: json['description'] as String?,
  isActive: json['isActive'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'description': instance.description,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
