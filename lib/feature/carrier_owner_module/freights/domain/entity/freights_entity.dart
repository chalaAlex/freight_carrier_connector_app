import 'package:equatable/equatable.dart';

class FreightsResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<FreightEntity>? freights;

  const FreightsResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.freights,
  });

  @override
  List<Object?> get props => [statusCode, message, total, freights];
}

class FreightEntity extends Equatable {
  final String? id;
  final String? freightOwnerId;
  final FreightCargoEntity? cargo;
  final FreightRouteEntity? route;
  final FreightScheduleEntity? schedule;
  final FreightTruckRequirementEntity? truckRequirement;
  final FreightPricingEntity? pricing;
  final String? status;
  final List<String>? images;
  final int? bidCount;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FreightEntity({
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

class FreightCargoEntity extends Equatable {
  final String? type;
  final String? description;
  final double? weightKg;
  final int? quantity;

  const FreightCargoEntity({
    this.type,
    this.description,
    this.weightKg,
    this.quantity,
  });

  @override
  List<Object?> get props => [type, description, weightKg, quantity];
}

class FreightRouteEntity extends Equatable {
  final FreightLocationEntity? pickup;
  final FreightLocationEntity? dropoff;

  const FreightRouteEntity({this.pickup, this.dropoff});

  @override
  List<Object?> get props => [pickup, dropoff];
}

class FreightLocationEntity extends Equatable {
  final String? region;
  final String? city;
  final String? address;

  const FreightLocationEntity({this.region, this.city, this.address});

  @override
  List<Object?> get props => [region, city, address];
}

class FreightScheduleEntity extends Equatable {
  final DateTime? pickupDate;
  final DateTime? deliveryDeadline;

  const FreightScheduleEntity({this.pickupDate, this.deliveryDeadline});

  @override
  List<Object?> get props => [pickupDate, deliveryDeadline];
}

class FreightTruckRequirementEntity extends Equatable {
  final String? type;
  final double? minCapacityKg;

  const FreightTruckRequirementEntity({this.type, this.minCapacityKg});

  @override
  List<Object?> get props => [type, minCapacityKg];
}

class FreightPricingEntity extends Equatable {
  final String? type;
  final double? amount;

  const FreightPricingEntity({this.type, this.amount});

  @override
  List<Object?> get props => [type, amount];
}
