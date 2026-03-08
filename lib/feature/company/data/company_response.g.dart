// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyBaseResponse _$CompanyBaseResponseFromJson(Map<String, dynamic> json) =>
    CompanyBaseResponse(
      status: json['status'] as String,
      results: (json['results'] as num).toInt(),
      data: CompanyData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyBaseResponseToJson(
  CompanyBaseResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'results': instance.results,
  'data': instance.data,
};

CompanyData _$CompanyDataFromJson(Map<String, dynamic> json) => CompanyData(
  companies: (json['companies'] as List<dynamic>)
      .map((e) => Company.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CompanyDataToJson(CompanyData instance) =>
    <String, dynamic>{'companies': instance.companies};

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  id: json['_id'] as String,
  legalEntityName: json['legalEntityName'] as String,
  companyType: json['companyType'] as String,
  companyRegistrationNumber: json['companyRegistrationNumber'] as String,
  headOfficeAddress: HeadOfficeAddress.fromJson(
    json['headOfficeAddress'] as Map<String, dynamic>,
  ),
  email: json['email'] as String,
  phone: json['phone'] as String,
  experience: (json['experience'] as num).toInt(),
  ratingAverage: (json['ratingAverage'] as num).toDouble(),
  ratingQuantity: (json['ratingQuantity'] as num).toInt(),
  completedShipments: (json['completedShipments'] as num).toInt(),
  fleetSize: (json['fleetSize'] as num).toInt(),
  isActive: json['isActive'] as bool,
  isVerified: json['isVerified'] as bool,
  isFeatured: json['isFeatured'] as bool,
  lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  score: (json['score'] as num).toDouble(),
  bannerImage: json['bannerImage'] as String?,
  logo: json['logo'] as String?,
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  '_id': instance.id,
  'legalEntityName': instance.legalEntityName,
  'companyType': instance.companyType,
  'companyRegistrationNumber': instance.companyRegistrationNumber,
  'headOfficeAddress': instance.headOfficeAddress,
  'email': instance.email,
  'phone': instance.phone,
  'experience': instance.experience,
  'ratingAverage': instance.ratingAverage,
  'ratingQuantity': instance.ratingQuantity,
  'completedShipments': instance.completedShipments,
  'fleetSize': instance.fleetSize,
  'isActive': instance.isActive,
  'isVerified': instance.isVerified,
  'isFeatured': instance.isFeatured,
  'lastActiveAt': instance.lastActiveAt.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'score': instance.score,
  'bannerImage': instance.bannerImage,
  'logo': instance.logo,
};

HeadOfficeAddress _$HeadOfficeAddressFromJson(Map<String, dynamic> json) =>
    HeadOfficeAddress(
      city: json['city'] as String,
      regionState: json['regionState'] as String,
      country: json['country'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$HeadOfficeAddressToJson(HeadOfficeAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'regionState': instance.regionState,
      'country': instance.country,
      '_id': instance.id,
    };
