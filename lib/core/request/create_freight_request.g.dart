// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_freight_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFreightRequest _$CreateFreightRequestFromJson(
  Map<String, dynamic> json,
) => CreateFreightRequest(
  cargo: Cargo.fromJson(json['cargo'] as Map<String, dynamic>),
  route: FreightRoute.fromJson(json['route'] as Map<String, dynamic>),
  schedule: Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
  truckRequirement: TruckRequirement.fromJson(
    json['truckRequirement'] as Map<String, dynamic>,
  ),
  pricing: Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
  image: (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$CreateFreightRequestToJson(
  CreateFreightRequest instance,
) => <String, dynamic>{
  'cargo': instance.cargo,
  'route': instance.route,
  'schedule': instance.schedule,
  'truckRequirement': instance.truckRequirement,
  'pricing': instance.pricing,
  'image': instance.image,
};

Cargo _$CargoFromJson(Map<String, dynamic> json) => Cargo(
  type: json['type'] as String,
  description: json['description'] as String,
  weightKg: (json['weightKg'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CargoToJson(Cargo instance) => <String, dynamic>{
  'type': instance.type,
  'description': instance.description,
  'weightKg': instance.weightKg,
  'quantity': instance.quantity,
};

FreightRoute _$FreightRouteFromJson(Map<String, dynamic> json) => FreightRoute(
  pickup: Location.fromJson(json['pickup'] as Map<String, dynamic>),
  dropoff: Location.fromJson(json['dropoff'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FreightRouteToJson(FreightRoute instance) =>
    <String, dynamic>{'pickup': instance.pickup, 'dropoff': instance.dropoff};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  region: json['region'] as String,
  city: json['city'] as String,
  address: json['address'] as String,
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'region': instance.region,
  'city': instance.city,
  'address': instance.address,
};

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
  pickupDate: DateTime.parse(json['pickupDate'] as String),
  deliveryDeadline: DateTime.parse(json['deliveryDeadline'] as String),
);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
  'pickupDate': instance.pickupDate.toIso8601String(),
  'deliveryDeadline': instance.deliveryDeadline.toIso8601String(),
};

TruckRequirement _$TruckRequirementFromJson(Map<String, dynamic> json) =>
    TruckRequirement(
      type: json['type'] as String,
      minCapacityKg: (json['minCapacityKg'] as num).toDouble(),
    );

Map<String, dynamic> _$TruckRequirementToJson(TruckRequirement instance) =>
    <String, dynamic>{
      'type': instance.type,
      'minCapacityKg': instance.minCapacityKg,
    };

Pricing _$PricingFromJson(Map<String, dynamic> json) => Pricing(
  type: json['type'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$PricingToJson(Pricing instance) => <String, dynamic>{
  'type': instance.type,
  'amount': instance.amount,
};
