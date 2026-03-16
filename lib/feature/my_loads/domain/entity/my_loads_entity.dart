import 'package:equatable/equatable.dart';

class MyLoadsResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<MyLoadsEntity>? freights;

  const MyLoadsResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.freights,
  });

  @override
  List<Object?> get props => [statusCode, message, total, freights];
}

class MyLoadsEntity extends Equatable {
  final String? id;
  final String? freightOwnerId;
  final CargoEntity? cargo;
  final RouteEntity? route;
  final ScheduleEntity? schedule;
  final TruckRequirementEntity? truckRequirement;
  final PricingEntity? pricing;
  final String? status;
  final List<String>? images;
  final int? bidCount;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MyLoadsEntity({
    this.id,
    this.freightOwnerId,
    this.cargo,
    this.route,
    this.schedule,
    this.truckRequirement,
    this.pricing,
    this.status,
    this.images,
    this.bidCount,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
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
        images,
        bidCount,
        isAvailable,
        createdAt,
        updatedAt,
      ];
}

class CargoEntity extends Equatable {
  final String? type;
  final String? description;
  final double? weightKg;
  final int? quantity;

  const CargoEntity({this.type, this.description, this.weightKg, this.quantity});

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

  const LocationEntity({this.region, this.city, this.address});

  @override
  List<Object?> get props => [region, city, address];
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
