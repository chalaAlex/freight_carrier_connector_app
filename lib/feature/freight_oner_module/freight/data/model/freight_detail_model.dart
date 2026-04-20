import 'package:json_annotation/json_annotation.dart';
part 'freight_detail_model.g.dart';

@JsonSerializable()
class FreightDetailBaseResponse {
  final int statusCode;
  final String message;
  final FreightData? data;

  FreightDetailBaseResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory FreightDetailBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$FreightDetailBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FreightDetailBaseResponseToJson(this);
}

@JsonSerializable()
class FreightData {
  final Freight? freight;

  FreightData({this.freight});

  factory FreightData.fromJson(Map<String, dynamic> json) =>
      _$FreightDataFromJson(json);

  Map<String, dynamic> toJson() => _$FreightDataToJson(this);
}

@JsonSerializable()
class Freight {
  @JsonKey(name: '_id')
  final String id;

  final String freightOwnerId;
  final Cargo cargo;
  final Route route;
  final Schedule schedule;
  final TruckRequirement truckRequirement;
  final Pricing pricing;

  final String status;
  final List<String> image;
  final int bidCount;
  final bool isAvailable;

  final DateTime createdAt;
  final DateTime updatedAt;

  Freight({
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

  factory Freight.fromJson(Map<String, dynamic> json) =>
      _$FreightFromJson(json);

  Map<String, dynamic> toJson() => _$FreightToJson(this);
}

@JsonSerializable()
class Cargo {
  final String type;
  final String description;
  final int weightKg;
  final int quantity;

  Cargo({
    required this.type,
    required this.description,
    required this.weightKg,
    required this.quantity,
  });

  factory Cargo.fromJson(Map<String, dynamic> json) => _$CargoFromJson(json);

  Map<String, dynamic> toJson() => _$CargoToJson(this);
}

@JsonSerializable()
class Route {
  final Location pickup;
  final Location dropoff;

  Route({required this.pickup, required this.dropoff});

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}

@JsonSerializable()
class Location {
  final String? region;
  final String? city;
  final String? address;

  Location({required this.region, required this.city, required this.address});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Schedule {
  final DateTime pickupDate;
  final DateTime deliveryDeadline;

  Schedule({required this.pickupDate, required this.deliveryDeadline});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class TruckRequirement {
  final String type;
  final int minCapacityKg;

  TruckRequirement({required this.type, required this.minCapacityKg});

  factory TruckRequirement.fromJson(Map<String, dynamic> json) =>
      _$TruckRequirementFromJson(json);

  Map<String, dynamic> toJson() => _$TruckRequirementToJson(this);
}

@JsonSerializable()
class Pricing {
  final String type;
  final int amount;

  Pricing({required this.type, required this.amount});

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);

  Map<String, dynamic> toJson() => _$PricingToJson(this);
}
