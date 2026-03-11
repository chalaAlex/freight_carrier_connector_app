import 'package:json_annotation/json_annotation.dart';
part 'company_response.g.dart';

@JsonSerializable()
class CompanyBaseResponse {
  final int statusCode;
  final int total;
  final CompanyData data;

  CompanyBaseResponse({
    required this.statusCode,
    required this.total,
    required this.data,
  });

  factory CompanyBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$CompanyBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyBaseResponseToJson(this);
}

@JsonSerializable()
class CompanyData {
  final List<Company> companies;

  CompanyData({required this.companies});

  factory CompanyData.fromJson(Map<String, dynamic> json) =>
      _$CompanyDataFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyDataToJson(this);
}

@JsonSerializable()
class Company {
  @JsonKey(name: '_id')
  final String? id;

  final String? legalEntityName;
  final String? companyType;
  final String? companyRegistrationNumber;
  final HeadOfficeAddress? headOfficeAddress;

  final String? email;
  final String? phone;
  final int? experience;
  final double? ratingAverage;
  final int? ratingQuantity;
  final int? completedShipments;
  final int? fleetSize;

  final bool? isActive;
  final bool? isVerified;
  final bool? isFeatured;

  final DateTime? lastActiveAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final double? score;

  final String? bannerImage;
  final String? logo;

  Company({
    this.id,
    this.legalEntityName,
    this.companyType,
    this.companyRegistrationNumber,
    this.headOfficeAddress,
    this.email,
    this.phone,
    this.experience,
    this.ratingAverage,
    this.ratingQuantity,
    this.completedShipments,
    this.fleetSize,
    this.isActive,
    this.isVerified,
    this.isFeatured,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
    this.score,
    this.bannerImage,
    this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

@JsonSerializable()
class HeadOfficeAddress {
  final String? city;
  final String? regionState;
  final String? country;

  @JsonKey(name: '_id')
  final String? id;

  HeadOfficeAddress({this.city, this.regionState, this.country, this.id});

  factory HeadOfficeAddress.fromJson(Map<String, dynamic> json) =>
      _$HeadOfficeAddressFromJson(json);

  Map<String, dynamic> toJson() => _$HeadOfficeAddressToJson(this);
}
