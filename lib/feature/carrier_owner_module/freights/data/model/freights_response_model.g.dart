// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freights_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreightsResponseModel _$FreightsResponseModelFromJson(
  Map<String, dynamic> json,
) => FreightsResponseModel(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  total: (json['total'] as num?)?.toInt(),
  freights: (json['data'] as List<dynamic>?)
      ?.map((e) => FreightItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FreightsResponseModelToJson(
  FreightsResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'total': instance.total,
  'data': instance.freights,
};

FreightItemModel _$FreightItemModelFromJson(
  Map<String, dynamic> json,
) => FreightItemModel(
  id: json['_id'] as String?,
  freightOwnerId: json['freightOwnerId'] as String?,
  cargo: json['cargo'] == null
      ? null
      : FreightCargoModel.fromJson(json['cargo'] as Map<String, dynamic>),
  route: json['route'] == null
      ? null
      : FreightRouteModel.fromJson(json['route'] as Map<String, dynamic>),
  schedule: json['schedule'] == null
      ? null
      : FreightScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
  truckRequirement: json['truckRequirement'] == null
      ? null
      : FreightTruckRequirementModel.fromJson(
          json['truckRequirement'] as Map<String, dynamic>,
        ),
  pricing: json['pricing'] == null
      ? null
      : FreightPricingModel.fromJson(json['pricing'] as Map<String, dynamic>),
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

Map<String, dynamic> _$FreightItemModelToJson(FreightItemModel instance) =>
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

FreightCargoModel _$FreightCargoModelFromJson(Map<String, dynamic> json) =>
    FreightCargoModel(
      type: json['type'] as String?,
      description: json['description'] as String?,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FreightCargoModelToJson(FreightCargoModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'weightKg': instance.weightKg,
      'quantity': instance.quantity,
    };

FreightRouteModel _$FreightRouteModelFromJson(
  Map<String, dynamic> json,
) => FreightRouteModel(
  pickup: json['pickup'] == null
      ? null
      : FreightLocationModel.fromJson(json['pickup'] as Map<String, dynamic>),
  dropoff: json['dropoff'] == null
      ? null
      : FreightLocationModel.fromJson(json['dropoff'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FreightRouteModelToJson(FreightRouteModel instance) =>
    <String, dynamic>{'pickup': instance.pickup, 'dropoff': instance.dropoff};

FreightLocationModel _$FreightLocationModelFromJson(
  Map<String, dynamic> json,
) => FreightLocationModel(
  region: json['region'] as String?,
  city: json['city'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$FreightLocationModelToJson(
  FreightLocationModel instance,
) => <String, dynamic>{
  'region': instance.region,
  'city': instance.city,
  'address': instance.address,
};

FreightScheduleModel _$FreightScheduleModelFromJson(
  Map<String, dynamic> json,
) => FreightScheduleModel(
  pickupDate: json['pickupDate'] == null
      ? null
      : DateTime.parse(json['pickupDate'] as String),
  deliveryDeadline: json['deliveryDeadline'] == null
      ? null
      : DateTime.parse(json['deliveryDeadline'] as String),
);

Map<String, dynamic> _$FreightScheduleModelToJson(
  FreightScheduleModel instance,
) => <String, dynamic>{
  'pickupDate': instance.pickupDate?.toIso8601String(),
  'deliveryDeadline': instance.deliveryDeadline?.toIso8601String(),
};

FreightTruckRequirementModel _$FreightTruckRequirementModelFromJson(
  Map<String, dynamic> json,
) => FreightTruckRequirementModel(
  type: json['type'] as String?,
  minCapacityKg: (json['minCapacityKg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FreightTruckRequirementModelToJson(
  FreightTruckRequirementModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'minCapacityKg': instance.minCapacityKg,
};

FreightPricingModel _$FreightPricingModelFromJson(Map<String, dynamic> json) =>
    FreightPricingModel(
      type: json['type'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FreightPricingModelToJson(
  FreightPricingModel instance,
) => <String, dynamic>{'type': instance.type, 'amount': instance.amount};
