import 'package:json_annotation/json_annotation.dart';
part 'freights_response_model.g.dart';

@JsonSerializable()
class FreightsResponseModel {
  final int? statusCode;
  final String? message;
  final int? total;

  @JsonKey(name: 'data')
  final List<FreightItemModel>? freights;

  FreightsResponseModel({
    this.statusCode,
    this.message,
    this.total,
    this.freights,
  });

  factory FreightsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    List<FreightItemModel>? freights;

    if (data is List) {
      freights = data
          .map((e) => FreightItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic>) {
      final rawList = data['freights'] as List<dynamic>?;
      freights = rawList
          ?.map((e) => FreightItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return FreightsResponseModel(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      total: json['total'] as int?,
      freights: freights,
    );
  }

  Map<String, dynamic> toJson() => _$FreightsResponseModelToJson(this);
}

@JsonSerializable()
class FreightItemModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? freightOwnerId;
  final FreightCargoModel? cargo;
  final FreightRouteModel? route;
  final FreightScheduleModel? schedule;
  final FreightTruckRequirementModel? truckRequirement;
  final FreightPricingModel? pricing;
  final String? status;
  final List<String>? image;
  final int? bidCount;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FreightItemModel({
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

  factory FreightItemModel.fromJson(Map<String, dynamic> json) =>
      _$FreightItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightItemModelToJson(this);
}

@JsonSerializable()
class FreightCargoModel {
  final String? type;
  final String? description;
  final double? weightKg;
  final int? quantity;

  FreightCargoModel({
    this.type,
    this.description,
    this.weightKg,
    this.quantity,
  });

  factory FreightCargoModel.fromJson(Map<String, dynamic> json) =>
      _$FreightCargoModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightCargoModelToJson(this);
}

@JsonSerializable()
class FreightRouteModel {
  final FreightLocationModel? pickup;
  final FreightLocationModel? dropoff;

  FreightRouteModel({this.pickup, this.dropoff});

  factory FreightRouteModel.fromJson(Map<String, dynamic> json) =>
      _$FreightRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightRouteModelToJson(this);
}

@JsonSerializable()
class FreightLocationModel {
  final String? region;
  final String? city;
  final String? address;

  FreightLocationModel({this.region, this.city, this.address});

  factory FreightLocationModel.fromJson(Map<String, dynamic> json) =>
      _$FreightLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightLocationModelToJson(this);
}

@JsonSerializable()
class FreightScheduleModel {
  final DateTime? pickupDate;
  final DateTime? deliveryDeadline;

  FreightScheduleModel({this.pickupDate, this.deliveryDeadline});

  factory FreightScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$FreightScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightScheduleModelToJson(this);
}

@JsonSerializable()
class FreightTruckRequirementModel {
  final String? type;
  final double? minCapacityKg;

  FreightTruckRequirementModel({this.type, this.minCapacityKg});

  factory FreightTruckRequirementModel.fromJson(Map<String, dynamic> json) =>
      _$FreightTruckRequirementModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightTruckRequirementModelToJson(this);
}

@JsonSerializable()
class FreightPricingModel {
  final String? type;
  final double? amount;

  FreightPricingModel({this.type, this.amount});

  factory FreightPricingModel.fromJson(Map<String, dynamic> json) =>
      _$FreightPricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreightPricingModelToJson(this);
}
