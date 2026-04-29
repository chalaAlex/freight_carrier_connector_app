import 'package:json_annotation/json_annotation.dart';
part 'my_loads_base_response_model.g.dart';

@JsonSerializable()
class MyLoadsBaseResponseModel {
  final int? statusCode;
  final String? message;
  final int? total;

  @JsonKey(name: 'data')
  final List<FreightModel>? freights;

  MyLoadsBaseResponseModel({
    this.statusCode,
    this.message,
    this.total,
    this.freights,
  });

  factory MyLoadsBaseResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    List<FreightModel>? freights;

    if (data is List) {
      // data is directly a list
      freights = data
          .map((e) => FreightModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic>) {
      // data is nested: { freights: [...] }
      final rawList = data['freights'] as List<dynamic>?;
      freights = rawList
          ?.map((e) => FreightModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return MyLoadsBaseResponseModel(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      total: json['total'] as int?,
      freights: freights,
    );
  }

  Map<String, dynamic> toJson() => _$MyLoadsBaseResponseModelToJson(this);
}

@JsonSerializable()
class FreightModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? freightOwnerId;
  final CargoModel? cargo;
  final RouteModel? route;
  final ScheduleModel? schedule;
  final TruckRequirementModel? truckRequirement;
  final PricingModel? pricing;

  final String? status;
  final List<String>? image;
  final int? bidCount;
  final bool? isAvailable;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  FreightModel({
    this.id,
    this.freightOwnerId,
    this.cargo,
    this.route,
    this.schedule,
    this.truckRequirement,
    this.pricing,
    this.status,
    this.image,
    this.bidCount,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory FreightModel.fromJson(Map<String, dynamic> json) =>
      _$FreightModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightModelToJson(this);
}

@JsonSerializable()
class CargoModel {
  final String? type;
  final String? description;
  final double? weightKg;
  final int? quantity;

  CargoModel({this.type, this.description, this.weightKg, this.quantity});

  factory CargoModel.fromJson(Map<String, dynamic> json) =>
      _$CargoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CargoModelToJson(this);
}

@JsonSerializable()
class RouteModel {
  final LocationModel? pickup;
  final LocationModel? dropoff;

  RouteModel({this.pickup, this.dropoff});

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}

@JsonSerializable()
class LocationModel {
  final String? region;
  final String? city;
  final String? address;

  LocationModel({this.region, this.city, this.address});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

@JsonSerializable()
class ScheduleModel {
  final DateTime? pickupDate;
  final DateTime? deliveryDeadline;

  ScheduleModel({this.pickupDate, this.deliveryDeadline});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);
}

@JsonSerializable()
class TruckRequirementModel {
  final String? type;
  final double? minCapacityKg;

  TruckRequirementModel({this.type, this.minCapacityKg});

  factory TruckRequirementModel.fromJson(Map<String, dynamic> json) =>
      _$TruckRequirementModelFromJson(json);

  Map<String, dynamic> toJson() => _$TruckRequirementModelToJson(this);
}

@JsonSerializable()
class PricingModel {
  final String? type;
  final double? amount;

  PricingModel({this.type, this.amount});

  factory PricingModel.fromJson(Map<String, dynamic> json) =>
      _$PricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PricingModelToJson(this);
}
