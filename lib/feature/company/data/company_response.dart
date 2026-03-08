import 'package:json_annotation/json_annotation.dart';
part 'company_response.g.dart';

@JsonSerializable()
class CompanyBaseResponse {
  final String status;
  final int results;
  final CompanyData data;

  CompanyBaseResponse({
    required this.status,
    required this.results,
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
  final String id;

  final String legalEntityName;
  final String companyType;
  final String companyRegistrationNumber;
  final HeadOfficeAddress headOfficeAddress;

  final String email;
  final String phone;
  final int experience;
  final double ratingAverage;
  final int ratingQuantity;
  final int completedShipments;
  final int fleetSize;

  final bool isActive;
  final bool isVerified;
  final bool isFeatured;

  final DateTime lastActiveAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final double score;

  final String? bannerImage;
  final String? logo;

  Company({
    required this.id,
    required this.legalEntityName,
    required this.companyType,
    required this.companyRegistrationNumber,
    required this.headOfficeAddress,
    required this.email,
    required this.phone,
    required this.experience,
    required this.ratingAverage,
    required this.ratingQuantity,
    required this.completedShipments,
    required this.fleetSize,
    required this.isActive,
    required this.isVerified,
    required this.isFeatured,
    required this.lastActiveAt,
    required this.createdAt,
    required this.updatedAt,
    required this.score,
    this.bannerImage,
    this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

@JsonSerializable()
class HeadOfficeAddress {
  final String city;
  final String regionState;
  final String country;

  @JsonKey(name: '_id')
  final String id;

  HeadOfficeAddress({
    required this.city,
    required this.regionState,
    required this.country,
    required this.id,
  });

  factory HeadOfficeAddress.fromJson(Map<String, dynamic> json) =>
      _$HeadOfficeAddressFromJson(json);

  Map<String, dynamic> toJson() => _$HeadOfficeAddressToJson(this);
}
