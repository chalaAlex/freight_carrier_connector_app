// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freight_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreightDetailBaseResponse _$FreightDetailBaseResponseFromJson(
  Map<String, dynamic> json,
) => FreightDetailBaseResponse(
  statusCode: (json['statusCode'] as num).toInt(),
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : FreightData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FreightDetailBaseResponseToJson(
  FreightDetailBaseResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

FreightData _$FreightDataFromJson(Map<String, dynamic> json) => FreightData(
  freight: json['freight'] == null
      ? null
      : Freight.fromJson(json['freight'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FreightDataToJson(FreightData instance) =>
    <String, dynamic>{'freight': instance.freight};

Freight _$FreightFromJson(Map<String, dynamic> json) => Freight(
  id: json['_id'] as String,
  freightOwnerId: json['freightOwnerId'] as String,
  cargo: Cargo.fromJson(json['cargo'] as Map<String, dynamic>),
  route: Route.fromJson(json['route'] as Map<String, dynamic>),
  schedule: Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
  truckRequirement: TruckRequirement.fromJson(
    json['truckRequirement'] as Map<String, dynamic>,
  ),
  pricing: Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
  status: json['status'] as String,
  image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
  bidCount: (json['bidCount'] as num).toInt(),
  isAvailable: json['isAvailable'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FreightToJson(Freight instance) => <String, dynamic>{
  '_id': instance.id,
  'freightOwnerId': instance.freightOwnerId,
  'cargo': instance.cargo,
  'route': instance.route,
  'schedule': instance.schedule,
  'truckRequirement': instance.truckRequirement,
  'pricing': instance.pricing,
  'status': instance.status,
  'image': instance.image,
  'bidCount': instance.bidCount,
  'isAvailable': instance.isAvailable,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

Cargo _$CargoFromJson(Map<String, dynamic> json) => Cargo(
  type: json['type'] as String,
  description: json['description'] as String,
  weightKg: (json['weightKg'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CargoToJson(Cargo instance) => <String, dynamic>{
  'type': instance.type,
  'description': instance.description,
  'weightKg': instance.weightKg,
  'quantity': instance.quantity,
};

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
  pickup: Location.fromJson(json['pickup'] as Map<String, dynamic>),
  dropoff: Location.fromJson(json['dropoff'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
  'pickup': instance.pickup,
  'dropoff': instance.dropoff,
};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  region: json['region'] as String?,
  city: json['city'] as String?,
  address: json['address'] as String?,
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
      minCapacityKg: (json['minCapacityKg'] as num).toInt(),
    );

Map<String, dynamic> _$TruckRequirementToJson(TruckRequirement instance) =>
    <String, dynamic>{
      'type': instance.type,
      'minCapacityKg': instance.minCapacityKg,
    };

Pricing _$PricingFromJson(Map<String, dynamic> json) => Pricing(
  type: json['type'] as String,
  amount: (json['amount'] as num).toInt(),
);

Map<String, dynamic> _$PricingToJson(Pricing instance) => <String, dynamic>{
  'type': instance.type,
  'amount': instance.amount,
};
