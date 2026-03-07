import 'package:equatable/equatable.dart';

class FeaturedCarrierResponseEntity extends Equatable {
  final String status;
  final int results;
  final FeaturedCarrierDataEntity data;

  const FeaturedCarrierResponseEntity({
    required this.status,
    required this.results,
    required this.data,
  });

  @override
  List<Object?> get props => [status, results, data];
}

class FeaturedCarrierDataEntity extends Equatable {
  final List<CarrierTruckEntity> featuredCarrier;

  const FeaturedCarrierDataEntity({
    required this.featuredCarrier,
  });

  @override
  List<Object?> get props => [featuredCarrier];
}

class CarrierTruckEntity extends Equatable {
  final String id;
  final String truckOwner;
  final List<String> driver;
  final String company;

  final String model;
  final String plateNumber;
  final String brand;
  final int loadCapacity;

  final List<String> features;
  final TruckLocationEntity location;

  final List<String> image;

  final String aboutTruck;

  final bool isAvailable;
  final bool isFeatured;
  final bool isVerified;

  final DateTime createdAt;
  final DateTime updatedAt;

  const CarrierTruckEntity({
    required this.id,
    required this.truckOwner,
    required this.driver,
    required this.company,
    required this.model,
    required this.plateNumber,
    required this.brand,
    required this.loadCapacity,
    required this.features,
    required this.location,
    required this.image,
    required this.aboutTruck,
    required this.isAvailable,
    required this.isFeatured,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        truckOwner,
        driver,
        company,
        model,
        plateNumber,
        brand,
        loadCapacity,
        features,
        location,
        image,
        aboutTruck,
        isAvailable,
        isFeatured,
        isVerified,
        createdAt,
        updatedAt,
      ];
}

class TruckLocationEntity extends Equatable {
  final String id;
  final String startLocation;
  final String destinationLocation;

  const TruckLocationEntity({
    required this.id,
    required this.startLocation,
    required this.destinationLocation,
  });

  @override
  List<Object?> get props => [
        id,
        startLocation,
        destinationLocation,
      ];
}