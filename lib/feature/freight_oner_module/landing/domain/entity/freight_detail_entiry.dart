import 'package:equatable/equatable.dart';

class FreightEntity extends Equatable {
  final String id;
  final String freightOwnerId;
  final CargoEntity cargo;
  final RouteEntity route;
  final ScheduleEntity schedule;
  final TruckRequirementEntity truckRequirement;
  final PricingEntity pricing;

  final String status;
  final List<String> image;
  final int bidCount;
  final bool isAvailable;

  final DateTime createdAt;
  final DateTime updatedAt;

  const FreightEntity({
    required this.id,
    required this.freightOwnerId,
    required this.cargo,
    required this.route,
    required this.schedule,
    required this.truckRequirement,
    required this.pricing,
    required this.status,
    required this.image,
    required this.bidCount,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        freightOwnerId,
        cargo,
        route,
        schedule,
        truckRequirement,
        pricing,
        status,
        image,
        bidCount,
        isAvailable,
        createdAt,
        updatedAt,
      ];
}

class CargoEntity extends Equatable {
  final String type;
  final String description;
  final int weightKg;
  final int quantity;

  const CargoEntity({
    required this.type,
    required this.description,
    required this.weightKg,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
        type,
        description,
        weightKg,
        quantity,
      ];
}

class RouteEntity extends Equatable {
  final LocationEntity pickup;
  final LocationEntity dropoff;

  const RouteEntity({
    required this.pickup,
    required this.dropoff,
  });

  @override
  List<Object?> get props => [
        pickup,
        dropoff,
      ];
}

class LocationEntity extends Equatable {
  final String region;
  final String city;
  final String address;

  const LocationEntity({
    required this.region,
    required this.city,
    required this.address,
  });

  @override
  List<Object?> get props => [
        region,
        city,
        address,
      ];
}

class ScheduleEntity extends Equatable {
  final DateTime pickupDate;
  final DateTime deliveryDeadline;

  const ScheduleEntity({
    required this.pickupDate,
    required this.deliveryDeadline,
  });

  @override
  List<Object?> get props => [
        pickupDate,
        deliveryDeadline,
      ];
}

class TruckRequirementEntity extends Equatable {
  final String type;
  final int minCapacityKg;

  const TruckRequirementEntity({
    required this.type,
    required this.minCapacityKg,
  });

  @override
  List<Object?> get props => [
        type,
        minCapacityKg,
      ];
}

class PricingEntity extends Equatable {
  final String type;
  final int amount;

  const PricingEntity({
    required this.type,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        type,
        amount,
      ];
}