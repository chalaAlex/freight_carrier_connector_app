// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cargo_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CargoTypeBaseResponse _$CargoTypeBaseResponseFromJson(
  Map<String, dynamic> json,
) => CargoTypeBaseResponse(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  total: (json['total'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CargoTypeDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CargoTypeBaseResponseToJson(
  CargoTypeBaseResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'total': instance.total,
  'data': instance.data,
};

CargoTypeDto _$CargoTypeDtoFromJson(Map<String, dynamic> json) => CargoTypeDto(
  id: json['_id'] as String?,
  cargoType: json['cargoType'] as String?,
);

Map<String, dynamic> _$CargoTypeDtoToJson(CargoTypeDto instance) =>
    <String, dynamic>{'_id': instance.id, 'cargoType': instance.cargoType};
