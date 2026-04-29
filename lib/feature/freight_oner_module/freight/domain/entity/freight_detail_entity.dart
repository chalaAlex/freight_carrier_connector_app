import 'package:equatable/equatable.dart';

class FreightDetailResponseEntity extends Equatable {
  final int statusCode;
  final String message;
  final FreightDetailEntity? freight;

  const FreightDetailResponseEntity({
    required this.statusCode,
    required this.message,
    this.freight,
  });

  @override
  List<Object?> get props => [statusCode, message, freight];
}

class FreightDetailEntity extends Equatable {
  final String id;
  final String freightOwnerId;
  final FreightDetailCargoEntity cargo;
  final FreightDetailRouteEntity route;
  final FreightDetailScheduleEntity schedule;
  final FreightDetailTruckRequirementEntity truckRequirement;
  final FreightDetailPricingEntity pricing;
  final String status;
  final List<String> image;
  final int bidCount;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FreightDetailEntity({
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

class FreightDetailCargoEntity extends Equatable {
  final String type;
  final String description;
  final int weightKg;
  final int quantity;

  const FreightDetailCargoEntity({
    required this.type,
    required this.description,
    required this.weightKg,
    required this.quantity,
  });

  @override
  List<Object?> get props => [type, description, weightKg, quantity];
}

class FreightDetailRouteEntity extends Equatable {
  final FreightDetailLocationEntity pickup;
  final FreightDetailLocationEntity dropoff;

  const FreightDetailRouteEntity({required this.pickup, required this.dropoff});

  @override
  List<Object?> get props => [pickup, dropoff];
}

class FreightDetailLocationEntity extends Equatable {
  final String region;
  final String city;
  final String address;

  const FreightDetailLocationEntity({
    required this.region,
    required this.city,
    required this.address,
  });

  @override
  List<Object?> get props => [region, city, address];
}

class FreightDetailScheduleEntity extends Equatable {
  final DateTime pickupDate;
  final DateTime deliveryDeadline;

  const FreightDetailScheduleEntity({
    required this.pickupDate,
    required this.deliveryDeadline,
  });

  @override
  List<Object?> get props => [pickupDate, deliveryDeadline];
}

class FreightDetailTruckRequirementEntity extends Equatable {
  final String type;
  final int minCapacityKg;

  const FreightDetailTruckRequirementEntity({
    required this.type,
    required this.minCapacityKg,
  });

  @override
  List<Object?> get props => [type, minCapacityKg];
}

class FreightDetailPricingEntity extends Equatable {
  final String type;
  final int amount;

  const FreightDetailPricingEntity({required this.type, required this.amount});

  @override
  List<Object?> get props => [type, amount];
}
