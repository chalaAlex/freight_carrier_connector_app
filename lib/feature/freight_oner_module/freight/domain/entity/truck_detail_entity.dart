import 'package:equatable/equatable.dart';

class TruckDetailBaseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final TruckDataEntity? data;

  const TruckDetailBaseEntity({this.statusCode, this.message, this.data});

  @override
  List<Object?> get props => [statusCode, message, data];
}

class TruckDataEntity extends Equatable {
  final TruckEntity? truck;

  const TruckDataEntity({this.truck});

  @override
  List<Object?> get props => [truck];
}

class TruckEntity extends Equatable {
  final String? id;
  final TruckOwnerEntity? truckOwner;
  final String? companyId;
  final String? companyName;
  final num? companyRatingAverage;
  final num? companyRatingQuantity;
  final String? model;
  final String? plateNumber;
  final String? brand;
  final num? pricePerKm;
  final num? loadCapacity;
  final List<String>? features;
  final String? location;
  final num? radiusKm;
  final List<String>? image;
  final String? aboutTruck;
  final bool? isAvailable;
  final bool? isItCompaniesCarrier;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TruckEntity({
    this.id,
    this.truckOwner,
    this.companyId,
    this.companyName,
    this.companyRatingAverage,
    this.companyRatingQuantity,
    this.model,
    this.plateNumber,
    this.brand,
    this.pricePerKm,
    this.loadCapacity,
    this.features,
    this.location,
    this.radiusKm,
    this.image,
    this.aboutTruck,
    this.isAvailable,
    this.isItCompaniesCarrier,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    truckOwner,
    companyId,
    companyName,
    companyRatingAverage,
    companyRatingQuantity,
    model,
    plateNumber,
    brand,
    pricePerKm,
    loadCapacity,
    features,
    location,
    radiusKm,
    image,
    aboutTruck,
    isAvailable,
    isItCompaniesCarrier,
    createdAt,
    updatedAt,
  ];
}

class TruckOwnerEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final num? ratingQuantity;
  final num? ratingAverage;

  const TruckOwnerEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.ratingQuantity,
    this.ratingAverage,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phone,
    ratingQuantity,
    ratingAverage,
  ];
}
