import 'package:equatable/equatable.dart';

class FreightBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final FreightEntity? data;

  const FreightBaseResponseEntity({this.statusCode, this.message, this.data});

  @override
  List<Object?> get props => [statusCode, message, data];
}

class FreightEntity extends Equatable {
  final String? id;
  final CargoEntity? cargo;
  final RouteEntity? route;
  final ScheduleEntity? schedule;
  final TruckRequirementEntity? truckRequirement;
  final PricingEntity? pricing;
  final String? status;
  final DateTime? createdAt;

  const FreightEntity({
    this.id,
    this.cargo,
    this.route,
    this.schedule,
    this.truckRequirement,
    this.pricing,
    this.status,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    cargo,
    route,
    schedule,
    truckRequirement,
    pricing,
    status,
    createdAt,
  ];
}

class CargoEntity extends Equatable {
  final String? type;
  final String? description;
  final double? weightKg;
  final int? quantity;

  const CargoEntity({
    this.type,
    this.description,
    this.weightKg,
    this.quantity,
  });

  @override
  List<Object?> get props => [type, description, weightKg, quantity];
}

class RouteEntity extends Equatable {
  final LocationEntity? pickup;
  final LocationEntity? dropoff;

  const RouteEntity({this.pickup, this.dropoff});

  @override
  List<Object?> get props => [pickup, dropoff];
}

class LocationEntity extends Equatable {
  final String? region;
  final String? city;
  final String? address;

  const LocationEntity({this.city, this.address, this.region});

  @override
  List<Object?> get props => [city, address, region];
}

class ScheduleEntity extends Equatable {
  final DateTime? pickupDate;
  final DateTime? deliveryDeadline;

  const ScheduleEntity({this.pickupDate, this.deliveryDeadline});

  @override
  List<Object?> get props => [pickupDate, deliveryDeadline];
}

class TruckRequirementEntity extends Equatable {
  final String? type;
  final double? minCapacityKg;

  const TruckRequirementEntity({this.type, this.minCapacityKg});

  @override
  List<Object?> get props => [type, minCapacityKg];
}

class PricingEntity extends Equatable {
  final String? type;
  final double? amount;

  const PricingEntity({this.type, this.amount});

  @override
  List<Object?> get props => [type, amount];
}
