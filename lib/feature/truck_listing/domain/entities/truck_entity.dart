import 'package:equatable/equatable.dart';

// enum TruckType { flatbed, refrigerated, dryVan }

class TruckBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<TruckEntity>? trucks;

  const TruckBaseResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.trucks,
  });

  @override
  List<Object?> get props => [statusCode, message, total, trucks];
}

class TruckEntity extends Equatable {
  final String id;
  final String model;
  final String plateNumber;
  final String brand;
  final double pricePerKm;
  final double loadCapacity;
  final List<String> features;
  final String location;
  final double radiusKm;
  final List<String> images;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TruckEntity({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.brand,
    required this.pricePerKm,
    required this.loadCapacity,
    required this.features,
    required this.location,
    required this.radiusKm,
    required this.images,
    required this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        model,
        plateNumber,
        brand,
        pricePerKm,
        loadCapacity,
        features,
        location,
        radiusKm,
        images,
        isAvailable,
        createdAt,
        updatedAt,
      ];
}