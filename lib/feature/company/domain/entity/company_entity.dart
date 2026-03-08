import 'package:equatable/equatable.dart';

class CompanyBaseResponseEntity extends Equatable {
  final String status;
  final int results;
  final CompanyDataEntity data;

  const CompanyBaseResponseEntity({
    required this.status,
    required this.results,
    required this.data,
  });

  @override
  List<Object?> get props => [status, results, data];
}

class CompanyDataEntity extends Equatable {
  final List<CompanyEntity> companies;

  const CompanyDataEntity({required this.companies});

  @override
  List<Object?> get props => [companies];
}

class CompanyEntity extends Equatable {
  final String id;
  final String legalEntityName;
  final String companyType;
  final String companyRegistrationNumber;
  final HeadOfficeAddressEntity headOfficeAddress;
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

  const CompanyEntity({
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

  @override
  List<Object?> get props => [
    id,
    legalEntityName,
    companyType,
    companyRegistrationNumber,
    headOfficeAddress,
    email,
    phone,
    experience,
    ratingAverage,
    ratingQuantity,
    completedShipments,
    fleetSize,
    isActive,
    isVerified,
    isFeatured,
    lastActiveAt,
    createdAt,
    updatedAt,
    score,
    bannerImage,
    logo,
  ];
}

class HeadOfficeAddressEntity extends Equatable {
  final String city;
  final String regionState;
  final String country;
  final String id;

  const HeadOfficeAddressEntity({
    required this.city,
    required this.regionState,
    required this.country,
    required this.id,
  });

  @override
  List<Object?> get props => [city, regionState, country, id];
}
