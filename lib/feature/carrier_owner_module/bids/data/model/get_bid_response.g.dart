// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bid_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBidResponse _$GetBidResponseFromJson(Map<String, dynamic> json) =>
    GetBidResponse(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : GetBidData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetBidResponseToJson(GetBidResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

GetBidData _$GetBidDataFromJson(Map<String, dynamic> json) => GetBidData(
  bidding: json['bidding'] == null
      ? null
      : GetBidModel.fromJson(json['bidding'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetBidDataToJson(GetBidData instance) =>
    <String, dynamic>{'bidding': instance.bidding};

GetBidModel _$GetBidModelFromJson(Map<String, dynamic> json) => GetBidModel(
  id: json['_id'] as String?,
  freightOwnerId: json['freightOwnerId'] == null
      ? null
      : GetBidFreightOwner.fromJson(
          json['freightOwnerId'] as Map<String, dynamic>,
        ),
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

Map<String, dynamic> _$GetBidModelToJson(GetBidModel instance) =>
    <String, dynamic>{
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

GetBidFreightOwner _$GetBidFreightOwnerFromJson(Map<String, dynamic> json) =>
    GetBidFreightOwner(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profileImage: json['profileImage'] as String?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble(),
      ratingQuantity: (json['ratingQuantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetBidFreightOwnerToJson(GetBidFreightOwner instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImage': instance.profileImage,
      'ratingAverage': instance.ratingAverage,
      'ratingQuantity': instance.ratingQuantity,
    };
