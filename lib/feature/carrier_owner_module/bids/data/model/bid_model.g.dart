// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBidResponseModel _$CreateBidResponseModelFromJson(
  Map<String, dynamic> json,
) => CreateBidResponseModel(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : BidData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateBidResponseModelToJson(
  CreateBidResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

BidData _$BidDataFromJson(Map<String, dynamic> json) => BidData(
  bid: json['bid'] == null
      ? null
      : BidModel.fromJson(json['bid'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BidDataToJson(BidData instance) => <String, dynamic>{
  'bid': instance.bid,
};

BidModel _$BidModelFromJson(Map<String, dynamic> json) => BidModel(
  id: json['_id'] as String?,
  freightOwnerId: json['freightOwnerId'] as String?,
  carrierOwnerId: json['carrierOwnerId'] as String?,
  carrierId: json['carrierId'] as String?,
  freightId: json['freightId'] as String?,
  bidAmount: (json['bidAmount'] as num?)?.toDouble(),
  message: json['message'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BidModelToJson(BidModel instance) => <String, dynamic>{
  '_id': instance.id,
  'freightOwnerId': instance.freightOwnerId,
  'carrierOwnerId': instance.carrierOwnerId,
  'carrierId': instance.carrierId,
  'freightId': instance.freightId,
  'bidAmount': instance.bidAmount,
  'message': instance.message,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
