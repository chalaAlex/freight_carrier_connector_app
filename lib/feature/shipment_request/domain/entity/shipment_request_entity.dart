import 'package:equatable/equatable.dart';

class RequestResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final RequestDataEntity? data;

  const RequestResponseEntity({this.statusCode, this.message, this.data});

  @override
  List<Object?> get props => [statusCode, message, data];
}

class RequestDataEntity extends Equatable {
  final ShipmentRequestEntity? shipmentRequest;

  const RequestDataEntity({this.shipmentRequest});

  @override
  List<Object?> get props => [shipmentRequest];
}

class ShipmentRequestEntity extends Equatable {
  final String? id;
  final String? freightOwnerId;
  final String? carrierOwnerId;
  final String? carrierId;
  final List<String>? freightIds;
  final String? status;
  final List<FreightSnapshotEntity>? freightSnapshots;
  final double? proposedPrice;
  final FreightOwnerContactEntity? freightOwnerContact;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  const ShipmentRequestEntity({
    this.id,
    this.freightOwnerId,
    this.carrierOwnerId,
    this.carrierId,
    this.freightIds,
    this.status,
    this.freightSnapshots,
    this.proposedPrice,
    this.freightOwnerContact,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  @override
  List<Object?> get props => [
    id,
    freightOwnerId,
    carrierOwnerId,
    carrierId,
    freightIds,
    status,
    freightSnapshots,
    proposedPrice,
    freightOwnerContact,
    createdAt,
    updatedAt,
    version,
  ];
}

class FreightSnapshotEntity extends Equatable {
  final String? freightId;
  final String? cargoType;
  final double? weight;
  final int? quantity;
  final LocationEntity? pickupLocation;
  final LocationEntity? deliveryLocation;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final String? specialRequirements;

  const FreightSnapshotEntity({
    this.freightId,
    this.cargoType,
    this.weight,
    this.quantity,
    this.pickupLocation,
    this.deliveryLocation,
    this.pickupDate,
    this.deliveryDate,
    this.specialRequirements,
  });

  @override
  List<Object?> get props => [
    freightId,
    cargoType,
    weight,
    quantity,
    pickupLocation,
    deliveryLocation,
    pickupDate,
    deliveryDate,
    specialRequirements,
  ];
}

class LocationEntity extends Equatable {
  final String? region;
  final String? city;
  final String? address;

  const LocationEntity({this.region, this.city, this.address});

  @override
  List<Object?> get props => [region, city, address];
}

class FreightOwnerContactEntity extends Equatable {
  final String? name;
  final String? companyName;
  final String? email;
  final String? phone;

  const FreightOwnerContactEntity({
    this.name,
    this.companyName,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [name, companyName, email, phone];
}
