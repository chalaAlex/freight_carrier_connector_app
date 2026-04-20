import 'package:json_annotation/json_annotation.dart';

part 'shipment_request_response_model.g.dart';

@JsonSerializable()
class RequestResponse {
  final int statusCode;
  final String message;
  final RequestData data;

  RequestResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestResponseToJson(this);
}

@JsonSerializable()
class RequestData {
  @JsonKey(name: 'request')
  final ShipmentRequestModel shipmentRequest;

  RequestData({required this.shipmentRequest});

  factory RequestData.fromJson(Map<String, dynamic> json) =>
      _$RequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDataToJson(this);
}

@JsonSerializable()
class ShipmentRequestModel {
  final String freightOwnerId;
  final String carrierOwnerId;
  final String carrierId;
  final List<String> freightIds;
  final String status;
  final List<FreightSnapshot> freightSnapshots;
  final double? proposedPrice;
  final FreightOwnerContact freightOwnerContact;

  @JsonKey(name: '_id')
  final String id;

  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(name: '__v')
  final int version;

  ShipmentRequestModel({
    required this.freightOwnerId,
    required this.carrierOwnerId,
    required this.carrierId,
    required this.freightIds,
    required this.status,
    required this.freightSnapshots,
    this.proposedPrice,
    required this.freightOwnerContact,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory ShipmentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentRequestModelToJson(this);
}

@JsonSerializable()
class FreightSnapshot {
  final String freightId;
  final String cargoType;
  final double weight;
  final int quantity;
  final SnapshotLocation pickupLocation;
  final SnapshotLocation deliveryLocation;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final String? specialRequirements;

  FreightSnapshot({
    required this.freightId,
    required this.cargoType,
    required this.weight,
    required this.quantity,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.pickupDate,
    required this.deliveryDate,
    this.specialRequirements,
  });

  factory FreightSnapshot.fromJson(Map<String, dynamic> json) =>
      _$FreightSnapshotFromJson(json);

  Map<String, dynamic> toJson() => _$FreightSnapshotToJson(this);
}

@JsonSerializable()
class SnapshotLocation {
  final String? region;
  final String? city;
  final String? address;

  SnapshotLocation({this.region, this.city, this.address});

  factory SnapshotLocation.fromJson(Map<String, dynamic> json) =>
      _$SnapshotLocationFromJson(json);

  Map<String, dynamic> toJson() => _$SnapshotLocationToJson(this);
}

@JsonSerializable()
class FreightOwnerContact {
  final String? name;
  final String? companyName;
  final String? email;
  final String? phone;

  FreightOwnerContact({this.name, this.companyName, this.email, this.phone});

  factory FreightOwnerContact.fromJson(Map<String, dynamic> json) =>
      _$FreightOwnerContactFromJson(json);

  Map<String, dynamic> toJson() => _$FreightOwnerContactToJson(this);
}
