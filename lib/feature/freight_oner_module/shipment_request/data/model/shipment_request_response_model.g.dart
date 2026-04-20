// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_request_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestResponse _$RequestResponseFromJson(Map<String, dynamic> json) =>
    RequestResponse(
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      data: RequestData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestResponseToJson(RequestResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

RequestData _$RequestDataFromJson(Map<String, dynamic> json) => RequestData(
  shipmentRequest: ShipmentRequestModel.fromJson(
    json['request'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RequestDataToJson(RequestData instance) =>
    <String, dynamic>{'request': instance.shipmentRequest};

ShipmentRequestModel _$ShipmentRequestModelFromJson(
  Map<String, dynamic> json,
) => ShipmentRequestModel(
  freightOwnerId: json['freightOwnerId'] as String,
  carrierOwnerId: json['carrierOwnerId'] as String,
  carrierId: json['carrierId'] as String,
  freightIds: (json['freightIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  status: json['status'] as String,
  freightSnapshots: (json['freightSnapshots'] as List<dynamic>)
      .map((e) => FreightSnapshot.fromJson(e as Map<String, dynamic>))
      .toList(),
  proposedPrice: (json['proposedPrice'] as num?)?.toDouble(),
  freightOwnerContact: FreightOwnerContact.fromJson(
    json['freightOwnerContact'] as Map<String, dynamic>,
  ),
  id: json['_id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  version: (json['__v'] as num).toInt(),
);

Map<String, dynamic> _$ShipmentRequestModelToJson(
  ShipmentRequestModel instance,
) => <String, dynamic>{
  'freightOwnerId': instance.freightOwnerId,
  'carrierOwnerId': instance.carrierOwnerId,
  'carrierId': instance.carrierId,
  'freightIds': instance.freightIds,
  'status': instance.status,
  'freightSnapshots': instance.freightSnapshots,
  'proposedPrice': instance.proposedPrice,
  'freightOwnerContact': instance.freightOwnerContact,
  '_id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  '__v': instance.version,
};

FreightSnapshot _$FreightSnapshotFromJson(Map<String, dynamic> json) =>
    FreightSnapshot(
      freightId: json['freightId'] as String,
      cargoType: json['cargoType'] as String,
      weight: (json['weight'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      pickupLocation: SnapshotLocation.fromJson(
        json['pickupLocation'] as Map<String, dynamic>,
      ),
      deliveryLocation: SnapshotLocation.fromJson(
        json['deliveryLocation'] as Map<String, dynamic>,
      ),
      pickupDate: DateTime.parse(json['pickupDate'] as String),
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      specialRequirements: json['specialRequirements'] as String?,
    );

Map<String, dynamic> _$FreightSnapshotToJson(FreightSnapshot instance) =>
    <String, dynamic>{
      'freightId': instance.freightId,
      'cargoType': instance.cargoType,
      'weight': instance.weight,
      'quantity': instance.quantity,
      'pickupLocation': instance.pickupLocation,
      'deliveryLocation': instance.deliveryLocation,
      'pickupDate': instance.pickupDate.toIso8601String(),
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'specialRequirements': instance.specialRequirements,
    };

SnapshotLocation _$SnapshotLocationFromJson(Map<String, dynamic> json) =>
    SnapshotLocation(
      region: json['region'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$SnapshotLocationToJson(SnapshotLocation instance) =>
    <String, dynamic>{
      'region': instance.region,
      'city': instance.city,
      'address': instance.address,
    };

FreightOwnerContact _$FreightOwnerContactFromJson(Map<String, dynamic> json) =>
    FreightOwnerContact(
      name: json['name'] as String?,
      companyName: json['companyName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$FreightOwnerContactToJson(
  FreightOwnerContact instance,
) => <String, dynamic>{
  'name': instance.name,
  'companyName': instance.companyName,
  'email': instance.email,
  'phone': instance.phone,
};
