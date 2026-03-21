// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateShipmentRequest _$CreateShipmentRequestFromJson(
  Map<String, dynamic> json,
) => CreateShipmentRequest(
  carrierId: json['carrierId'] as String,
  freightIds: (json['freightIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  proposedPrice: (json['proposedPrice'] as num?)?.toInt(),
);

Map<String, dynamic> _$CreateShipmentRequestToJson(
  CreateShipmentRequest instance,
) => <String, dynamic>{
  'carrierId': instance.carrierId,
  'freightIds': instance.freightIds,
  'proposedPrice': instance.proposedPrice,
};
