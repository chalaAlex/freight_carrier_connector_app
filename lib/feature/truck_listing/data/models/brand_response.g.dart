// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandBaseResponse _$BrandBaseResponseFromJson(Map<String, dynamic> json) =>
    BrandBaseResponse(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      total: (json['total'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : BrandData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BrandBaseResponseToJson(BrandBaseResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'total': instance.total,
      'data': instance.data,
    };

BrandData _$BrandDataFromJson(Map<String, dynamic> json) => BrandData(
  brands: (json['brands'] as List<dynamic>?)
      ?.map((e) => Brand.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BrandDataToJson(BrandData instance) => <String, dynamic>{
  'brands': instance.brands,
};

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  isActive: json['isActive'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
