import 'package:equatable/equatable.dart';

enum TruckType { flatbed, refrigerated, dryVan }

class Truck extends Equatable {
  final String id;
  final String model;
  final String company;
  final double pricePerDay;
  final double pricePerHour;
  final double capacityTons;
  final TruckType type;
  final String location;
  final double radiusKm;
  final String imageUrl;
  final bool isAvailable;

  const Truck({
    required this.id,
    required this.model,
    required this.company,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.capacityTons,
    required this.type,
    required this.location,
    required this.radiusKm,
    required this.imageUrl,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
        id,
        model,
        company,
        pricePerDay,
        pricePerHour,
        capacityTons,
        type,
        location,
        radiusKm,
        imageUrl,
        isAvailable,
      ];
}
