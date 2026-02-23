// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freight_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreightBaseResponse _$FreightBaseResponseFromJson(Map<String, dynamic> json) =>
    FreightBaseResponse(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : FreightDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FreightBaseResponseToJson(
  FreightBaseResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

FreightDto _$FreightDtoFromJson(Map<String, dynamic> json) => FreightDto(
  id: json['_id'] as String?,
  cargo: json['cargo'] == null
      ? null
      : CargoDto.fromJson(json['cargo'] as Map<String, dynamic>),
  route: json['route'] == null
      ? null
      : RouteDto.fromJson(json['route'] as Map<String, dynamic>),
  schedule: json['schedule'] == null
      ? null
      : ScheduleDto.fromJson(json['schedule'] as Map<String, dynamic>),
  truckRequirement: json['truckRequirement'] == null
      ? null
      : TruckRequirementDto.fromJson(
          json['truckRequirement'] as Map<String, dynamic>,
        ),
  pricing: json['pricing'] == null
      ? null
      : PricingDto.fromJson(json['pricing'] as Map<String, dynamic>),
  status: json['status'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$FreightDtoToJson(FreightDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'cargo': instance.cargo,
      'route': instance.route,
      'schedule': instance.schedule,
      'truckRequirement': instance.truckRequirement,
      'pricing': instance.pricing,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };

CargoDto _$CargoDtoFromJson(Map<String, dynamic> json) => CargoDto(
  type: json['type'] as String?,
  description: json['description'] as String?,
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num?)?.toInt(),
);

Map<String, dynamic> _$CargoDtoToJson(CargoDto instance) => <String, dynamic>{
  'type': instance.type,
  'description': instance.description,
  'weightKg': instance.weightKg,
  'quantity': instance.quantity,
};

RouteDto _$RouteDtoFromJson(Map<String, dynamic> json) => RouteDto(
  pickup: json['pickup'] == null
      ? null
      : LocationDto.fromJson(json['pickup'] as Map<String, dynamic>),
  dropoff: json['dropoff'] == null
      ? null
      : LocationDto.fromJson(json['dropoff'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteDtoToJson(RouteDto instance) => <String, dynamic>{
  'pickup': instance.pickup,
  'dropoff': instance.dropoff,
};

LocationDto _$LocationDtoFromJson(Map<String, dynamic> json) => LocationDto(
  city: json['city'] as String?,
  address: json['address'] as String?,
  region: json['region'] as String?,
);

Map<String, dynamic> _$LocationDtoToJson(LocationDto instance) =>
    <String, dynamic>{
      'region': instance.region,
      'city': instance.city,
      'address': instance.address,
    };

ScheduleDto _$ScheduleDtoFromJson(Map<String, dynamic> json) => ScheduleDto(
  pickupDate: json['pickupDate'] as String?,
  deliveryDeadline: json['deliveryDeadline'] as String?,
);

Map<String, dynamic> _$ScheduleDtoToJson(ScheduleDto instance) =>
    <String, dynamic>{
      'pickupDate': instance.pickupDate,
      'deliveryDeadline': instance.deliveryDeadline,
    };

TruckRequirementDto _$TruckRequirementDtoFromJson(Map<String, dynamic> json) =>
    TruckRequirementDto(
      type: json['type'] as String?,
      minCapacityKg: (json['minCapacityKg'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TruckRequirementDtoToJson(
  TruckRequirementDto instance,
) => <String, dynamic>{
  'type': instance.type,
  'minCapacityKg': instance.minCapacityKg,
};

PricingDto _$PricingDtoFromJson(Map<String, dynamic> json) => PricingDto(
  type: json['type'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PricingDtoToJson(PricingDto instance) =>
    <String, dynamic>{'type': instance.type, 'amount': instance.amount};
