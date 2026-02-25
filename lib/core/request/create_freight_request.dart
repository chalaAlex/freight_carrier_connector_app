import 'package:json_annotation/json_annotation.dart';

part 'create_freight_request.g.dart';

@JsonSerializable()
class CreateFreightRequest {
  final Cargo cargo;
  @JsonKey(name: 'route')
  final FreightRoute route;
  final Schedule schedule;
  final TruckRequirement truckRequirement;
  final Pricing pricing;
  final List<String>? image;

  const CreateFreightRequest({
    required this.cargo,
    required this.route,
    required this.schedule,
    required this.truckRequirement,
    required this.pricing,
    this.image,
  });

  factory CreateFreightRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFreightRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFreightRequestToJson(this);
}

@JsonSerializable()
class Cargo {
  final String type;
  final String description;
  final double weightKg;
  final int quantity;

  const Cargo({
    required this.type,
    required this.description,
    required this.weightKg,
    required this.quantity,
  });

  factory Cargo.fromJson(Map<String, dynamic> json) => _$CargoFromJson(json);
  Map<String, dynamic> toJson() => _$CargoToJson(this);
}

@JsonSerializable()
class FreightRoute {
  final Location pickup;
  final Location dropoff;

  const FreightRoute({required this.pickup, required this.dropoff});

  factory FreightRoute.fromJson(Map<String, dynamic> json) =>
      _$FreightRouteFromJson(json);
  Map<String, dynamic> toJson() => _$FreightRouteToJson(this);
}

@JsonSerializable()
class Location {
  final String region;
  final String city;
  final String address;

  const Location({
    required this.region,
    required this.city,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Schedule {
  final DateTime pickupDate;
  final DateTime deliveryDeadline;

  const Schedule({required this.pickupDate, required this.deliveryDeadline});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class TruckRequirement {
  final String type;
  final double minCapacityKg;

  const TruckRequirement({required this.type, required this.minCapacityKg});

  factory TruckRequirement.fromJson(Map<String, dynamic> json) =>
      _$TruckRequirementFromJson(json);
  Map<String, dynamic> toJson() => _$TruckRequirementToJson(this);
}

@JsonSerializable()
class Pricing {
  final String type;
  final double amount;

  const Pricing({required this.type, required this.amount});

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);
  Map<String, dynamic> toJson() => _$PricingToJson(this);
}
