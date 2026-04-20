// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_loads_base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyLoadsBaseResponseModel _$MyLoadsBaseResponseModelFromJson(
  Map<String, dynamic> json,
) => MyLoadsBaseResponseModel(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  total: (json['total'] as num?)?.toInt(),
  freights: (json['data'] as List<dynamic>?)
      ?.map((e) => FreightModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MyLoadsBaseResponseModelToJson(
  MyLoadsBaseResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'total': instance.total,
  'data': instance.freights,
};

FreightModel _$FreightModelFromJson(Map<String, dynamic> json) => FreightModel(
  id: json['_id'] as String?,
  freightOwnerId: json['freightOwnerId'] as String?,
  cargo: json['cargo'] == null
      ? null
      : CargoModel.fromJson(json['cargo'] as Map<String, dynamic>),
  route: json['route'] == null
      ? null
      : RouteModel.fromJson(json['route'] as Map<String, dynamic>),
  schedule: json['schedule'] == null
      ? null
      : ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
  truckRequirement: json['truckRequirement'] == null
      ? null
      : TruckRequirementModel.fromJson(
          json['truckRequirement'] as Map<String, dynamic>,
        ),
  pricing: json['pricing'] == null
      ? null
      : PricingModel.fromJson(json['pricing'] as Map<String, dynamic>),
  status: json['status'] as String?,
  image: (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
  bidCount: (json['bidCount'] as num?)?.toInt(),
  isAvailable: json['isAvailable'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FreightModelToJson(FreightModel instance) =>
    <String, dynamic>{
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
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

CargoModel _$CargoModelFromJson(Map<String, dynamic> json) => CargoModel(
  type: json['type'] as String?,
  description: json['description'] as String?,
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num?)?.toInt(),
);

Map<String, dynamic> _$CargoModelToJson(CargoModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'weightKg': instance.weightKg,
      'quantity': instance.quantity,
    };

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => RouteModel(
  pickup: json['pickup'] == null
      ? null
      : LocationModel.fromJson(json['pickup'] as Map<String, dynamic>),
  dropoff: json['dropoff'] == null
      ? null
      : LocationModel.fromJson(json['dropoff'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{'pickup': instance.pickup, 'dropoff': instance.dropoff};

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      region: json['region'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'region': instance.region,
      'city': instance.city,
      'address': instance.address,
    };

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      pickupDate: json['pickupDate'] == null
          ? null
          : DateTime.parse(json['pickupDate'] as String),
      deliveryDeadline: json['deliveryDeadline'] == null
          ? null
          : DateTime.parse(json['deliveryDeadline'] as String),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'pickupDate': instance.pickupDate?.toIso8601String(),
      'deliveryDeadline': instance.deliveryDeadline?.toIso8601String(),
    };

TruckRequirementModel _$TruckRequirementModelFromJson(
  Map<String, dynamic> json,
) => TruckRequirementModel(
  type: json['type'] as String?,
  minCapacityKg: (json['minCapacityKg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TruckRequirementModelToJson(
  TruckRequirementModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'minCapacityKg': instance.minCapacityKg,
};

PricingModel _$PricingModelFromJson(Map<String, dynamic> json) => PricingModel(
  type: json['type'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PricingModelToJson(PricingModel instance) =>
    <String, dynamic>{'type': instance.type, 'amount': instance.amount};
