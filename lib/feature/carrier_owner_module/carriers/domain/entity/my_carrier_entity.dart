import 'package:equatable/equatable.dart';

class CarrierDocumentsEntity extends Equatable {
  final String? vehicleRegistration;
  final String? tradeLicense;
  final String? ownerDigitalId;

  const CarrierDocumentsEntity({
    this.vehicleRegistration,
    this.tradeLicense,
    this.ownerDigitalId,
  });

  @override
  List<Object?> get props => [
    vehicleRegistration,
    tradeLicense,
    ownerDigitalId,
  ];
}

class MyCarriersResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final List<MyCarrierEntity>? carriers;

  const MyCarriersResponseEntity({
    this.statusCode,
    this.message,
    this.carriers,
  });

  @override
  List<Object?> get props => [statusCode, message, carriers];
}

class MyCarrierEntity extends Equatable {
  final String id;
  final String? model;
  final String? plateNumber;
  final String? brand;
  final double? loadCapacity;
  final List<String>? features;
  final String? startLocation;
  final String? destinationLocation;
  final List<String>? images;
  final String? aboutTruck;
  final bool? isAvailable;
  final bool? isVerified;
  final CarrierDocumentsEntity? documents;

  const MyCarrierEntity({
    required this.id,
    this.model,
    this.plateNumber,
    this.brand,
    this.loadCapacity,
    this.features,
    this.startLocation,
    this.destinationLocation,
    this.images,
    this.aboutTruck,
    this.isAvailable,
    this.isVerified,
    this.documents,
  });

  String get displayName =>
      [brand, model].whereType<String>().join(' ').trim().isNotEmpty
      ? '${brand ?? ''} ${model ?? ''}'.trim()
      : 'Truck';

  @override
  List<Object?> get props => [
    id,
    model,
    plateNumber,
    brand,
    loadCapacity,
    features,
    startLocation,
    destinationLocation,
    images,
    aboutTruck,
    isAvailable,
    isVerified,
    documents,
  ];
}
