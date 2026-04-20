import 'package:json_annotation/json_annotation.dart';
part 'my_carriers_model.g.dart';

@JsonSerializable()
class MyCarriersResponseModel {
  final int? statusCode;
  final String? message;
  final int? results;
  final MyCarriersData? data;

  MyCarriersResponseModel({
    this.statusCode,
    this.message,
    this.results,
    this.data,
  });

  factory MyCarriersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MyCarriersResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyCarriersResponseModelToJson(this);
}

@JsonSerializable()
class MyCarriersData {
  final List<MyCarrierModel>? carriers;

  MyCarriersData({this.carriers});

  factory MyCarriersData.fromJson(Map<String, dynamic> json) =>
      _$MyCarriersDataFromJson(json);

  Map<String, dynamic> toJson() => _$MyCarriersDataToJson(this);
}

@JsonSerializable()
class MyCarrierModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? model;
  final String? plateNumber;
  final String? brand;
  final double? loadCapacity;
  final List<String>? features;
  final MyCarrierOperatingCorrider? operatingCorrider;
  final List<String>? image;
  final String? aboutTruck;
  final bool? isAvailable;
  final bool? isVerified;
  final CarrierDocumentsModel? documents;

  MyCarrierModel({
    this.id,
    this.model,
    this.plateNumber,
    this.brand,
    this.loadCapacity,
    this.features,
    this.operatingCorrider,
    this.image,
    this.aboutTruck,
    this.isAvailable,
    this.isVerified,
    this.documents,
  });

  factory MyCarrierModel.fromJson(Map<String, dynamic> json) =>
      _$MyCarrierModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyCarrierModelToJson(this);
}

@JsonSerializable()
class CarrierDocumentsModel {
  final String? vehicleRegistration;
  final String? tradeLicense;
  final String? ownerDigitalId;

  CarrierDocumentsModel({
    this.vehicleRegistration,
    this.tradeLicense,
    this.ownerDigitalId,
  });

  factory CarrierDocumentsModel.fromJson(Map<String, dynamic> json) =>
      _$CarrierDocumentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierDocumentsModelToJson(this);
}

@JsonSerializable()
class MyCarrierOperatingCorrider {
  final String? startLocation;
  final String? destinationLocation;

  MyCarrierOperatingCorrider({this.startLocation, this.destinationLocation});

  factory MyCarrierOperatingCorrider.fromJson(Map<String, dynamic> json) =>
      _$MyCarrierOperatingCorriderFromJson(json);

  Map<String, dynamic> toJson() => _$MyCarrierOperatingCorriderToJson(this);
}
