import 'package:clean_architecture/cofig/base_mapper.dart';
import 'package:clean_architecture/feature/company/data/model/company_response.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';
import 'package:clean_architecture/feature/freight/data/model/cargo_type_model.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_response_model.dart';
import 'package:clean_architecture/feature/freight/data/model/location_model.dart';
import 'package:clean_architecture/feature/freight/data/model/truck_detail_model.dart'
    as detail;
import 'package:clean_architecture/feature/freight/domain/entity/cargo_type_entity.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_entity.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart'
    as detail_entity;
import 'package:clean_architecture/feature/landing/data/model/featured_carrier_response.dart';
import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:clean_architecture/feature/signup/data/models/login_model.dart';
import 'package:clean_architecture/feature/signup/data/models/sign_up_model.dart';
import 'package:clean_architecture/feature/signup/domain/entities/login_entity.dart';
import 'package:clean_architecture/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck_entity.dart';

class UserMapper extends BaseMapper<UserResponse, UserModel> {
  @override
  UserModel mapToEntity(UserResponse dto) {
    return UserModel(
      id: dto.id,
      firstName: dto.firstName,
      lastName: dto.lastName,
      email: dto.email,
      phone: dto.phone,
      role: dto.role,
      createdAt: DateTime.tryParse(dto.createdAt ?? ''),
    );
  }
}

class SignUpDataMapper extends BaseMapper<SignUpData, SignUpDataModel> {
  final UserMapper _userMapper = UserMapper();

  @override
  SignUpDataModel mapToEntity(SignUpData dto) {
    return SignUpDataModel(user: _userMapper.mapNullable(dto.user));
  }
}

class SignUpResponseMapper
    extends BaseMapper<SignUpModel, SignUpBaseResponseEntity> {
  final SignUpDataMapper _dataMapper = SignUpDataMapper();

  @override
  SignUpBaseResponseEntity mapToEntity(SignUpModel dto) {
    return SignUpBaseResponseEntity(
      message: dto.message,
      statusCode: dto.statusCode,
      data: _dataMapper.mapNullable(dto.data),
    );
  }
}

class LoginResponseMapper
    extends BaseMapper<LoginBaseResponse, LoginBaseResponseEntity> {
  final LoginDataMapper _dataMapper = LoginDataMapper();

  @override
  LoginBaseResponseEntity mapToEntity(LoginBaseResponse dto) {
    return LoginBaseResponseEntity(
      statusCode: dto.statusCode,
      message: dto.message,
      token: dto.token,
      data: _dataMapper.mapNullable(dto.data),
    );
  }
}

class LoginDataMapper extends BaseMapper<LoginDataModel, LoginDataEntity> {
  @override
  LoginDataEntity mapToEntity(LoginDataModel dto) {
    final user = dto.user;
    return LoginDataEntity(
      id: user?.id,
      firstName: user?.firstName,
      lastName: user?.lastName,
      email: user?.email,
      phone: user?.phone,
      role: user?.role,
      createdAt: DateTime.tryParse(user?.createdAt ?? ''),
    );
  }
}

class TruckResponseMapper
    extends BaseMapper<TruckBaseResponse, TruckBaseResponseEntity> {
  final TruckDataMapper _dataMapper = TruckDataMapper();

  @override
  TruckBaseResponseEntity mapToEntity(TruckBaseResponse dto) {
    return TruckBaseResponseEntity(
      statusCode: dto.statusCode,
      message: dto.message,
      total: dto.total,
      trucks: dto.data?.trucks?.map((e) => _dataMapper.mapToEntity(e)).toList(),
    );
  }
}

class TruckDataMapper extends BaseMapper<TruckDto, TruckEntity> {
  @override
  TruckEntity mapToEntity(TruckDto dto) {
    return TruckEntity(
      id: dto.id,
      model: dto.model,
      plateNumber: dto.plateNumber,
      brand: dto.brand,
      pricePerKm: double.tryParse(dto.pricePerKm.toString()) ?? 0.0,
      loadCapacity: double.tryParse(dto.loadCapacity.toString()) ?? 0.0,
      features: dto.features,
      location: dto.location,
      radiusKm: double.tryParse(dto.radiusKm.toString()) ?? 0.0,
      images: dto.image,
      isAvailable: dto.isAvailable,
      createdAt: dto.createdAt != null
          ? DateTime.tryParse(dto.createdAt!)
          : null,
      updatedAt: dto.updatedAt != null
          ? DateTime.tryParse(dto.updatedAt!)
          : null,
    );
  }
}

extension FreightDtoMapper on FreightDto {
  FreightEntity toEntity() {
    return FreightEntity(
      id: id,
      status: status,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      cargo: cargo?.toEntity(),
      route: route?.toEntity(),
      schedule: schedule?.toEntity(),
      truckRequirement: truckRequirement?.toEntity(),
      pricing: pricing?.toEntity(),
    );
  }
}

extension CargoDtoMapper on CargoDto {
  CargoEntity toEntity() {
    return CargoEntity(
      type: type,
      description: description,
      weightKg: weightKg,
      quantity: quantity,
    );
  }
}

extension RouteDtoMapper on RouteDto {
  RouteEntity toEntity() {
    return RouteEntity(
      pickup: pickup?.toEntity(),
      dropoff: dropoff?.toEntity(),
    );
  }
}

extension LocationDtoMapper on LocationDto {
  LocationEntity toEntity() {
    return LocationEntity(city: city, address: address);
  }
}

extension ScheduleDtoMapper on ScheduleDto {
  ScheduleEntity toEntity() {
    return ScheduleEntity(
      pickupDate: pickupDate != null ? DateTime.parse(pickupDate!) : null,
      deliveryDeadline: deliveryDeadline != null
          ? DateTime.parse(deliveryDeadline!)
          : null,
    );
  }
}

extension TruckRequirementDtoMapper on TruckRequirementDto {
  TruckRequirementEntity toEntity() {
    return TruckRequirementEntity(type: type, minCapacityKg: minCapacityKg);
  }
}

extension PricingDtoMapper on PricingDto {
  PricingEntity toEntity() {
    return PricingEntity(type: type, amount: amount);
  }
}

// Location
extension RegionDtoMapper on RegionDto {
  RegionEntity toEntity() {
    return RegionEntity(id: id, region: region, cities: city);
  }
}

extension RegionBaseResponseMapper on LocationBaseResponse {
  RegionBaseResponseEntity toEntity() {
    return RegionBaseResponseEntity(
      statusCode: statusCode,
      message: message,
      data: data?.map((e) => e.toEntity()).toList(),
    );
  }
}

// CargoType
extension CargoTypeBaseResponseMapper on CargoTypeBaseResponse {
  CargoTypeBaseResponseEntity toEntity() {
    return CargoTypeBaseResponseEntity(
      statusCode: statusCode,
      message: message,
      total: total,
      data: data?.map((e) => e.toEntity()).toList(),
    );
  }
}

extension CargoTypeDtoMapper on CargoTypeDto {
  CargoTypeEntity toEntity() {
    return CargoTypeEntity(id: id, cargoType: cargoType);
  }
}

// Truck Detail Mappers
extension TruckDetailBaseResponseMapper on detail.TruckDetailBaseResponse {
  detail_entity.TruckDetailBaseEntity toEntity() {
    return detail_entity.TruckDetailBaseEntity(
      statusCode: statusCode,
      message: message,
      data: data?.toEntity(),
    );
  }
}

extension TruckDetailDataMapper on detail.TruckData {
  detail_entity.TruckDataEntity toEntity() {
    return detail_entity.TruckDataEntity(truck: carrier?.toEntity());
  }
}

extension TruckDetailDtoMapper on detail.TruckDto {
  detail_entity.TruckEntity toEntity() {
    return detail_entity.TruckEntity(
      id: id,
      truckOwner: truckOwner?.toEntity(),
      model: model,
      plateNumber: plateNumber,
      brand: brand,
      pricePerKm: pricePerKm,
      loadCapacity: loadCapacity,
      features: features,
      location: location,
      radiusKm: radiusKm,
      image: image,
      aboutTruck: aboutTruck,
      isAvailable: isAvailable,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}

extension TruckOwnerDtoMapper on detail.TruckOwnerDto {
  detail_entity.TruckOwnerEntity toEntity() {
    return detail_entity.TruckOwnerEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      ratingQuantity: ratingQuantity,
      ratingAverage: ratingAverage,
    );
  }
}

// Featured Carrier Mapper
extension CarrierTruckMapper on CarrierTruck {
  CarrierTruckEntity toEntity() {
    return CarrierTruckEntity(
      id: id,
      truckOwner: truckOwner,
      driver: driver,
      company: company,
      model: model,
      plateNumber: plateNumber,
      brand: brand,
      loadCapacity: loadCapacity,
      features: features,
      operatingCorrider: operatingCorrider.toEntity(),
      image: image,
      aboutTruck: aboutTruck,
      isAvailable: isAvailable,
      isFeatured: isFeatured,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension TruckLocationMapper on TruckLocation {
  OperatingCorriderEntity toEntity() {
    return OperatingCorriderEntity(
      id: id,
      startLocation: startLocation,
      destinationLocation: destinationLocation,
    );
  }
}

// Company response-entity mapper
extension CompanyBaseResponseMapper on CompanyBaseResponse {
  CompanyBaseResponseEntity toEntity() {
    return CompanyBaseResponseEntity(
      statusCode: statusCode,
      total: total,
      data: data.toEntity(),
    );
  }
}

extension CompanyDataMapper on CompanyData {
  CompanyDataEntity toEntity() {
    return CompanyDataEntity(
      companies: companies.map((e) => e.toEntity()).toList(),
    );
  }
}

extension CompanyMapper on Company {
  CompanyEntity toEntity() {
    return CompanyEntity(
      id: id ?? '',
      legalEntityName: legalEntityName ?? '',
      companyType: companyType ?? '',
      companyRegistrationNumber: companyRegistrationNumber ?? '',
      headOfficeAddress:
          headOfficeAddress?.toEntity() ??
          const HeadOfficeAddressEntity(
            city: '',
            regionState: '',
            country: '',
            id: '',
          ),
      email: email ?? '',
      phone: phone ?? '',
      experience: experience ?? 0,
      ratingAverage: ratingAverage ?? 0.0,
      ratingQuantity: ratingQuantity ?? 0,
      completedShipments: completedShipments ?? 0,
      fleetSize: fleetSize ?? 0,
      isActive: isActive ?? false,
      isVerified: isVerified ?? false,
      isFeatured: isFeatured ?? false,
      lastActiveAt: lastActiveAt ?? DateTime.now(),
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      score: score ?? 0.0,
      bannerImage: bannerImage,
      logo: logo,
    );
  }
}

extension HeadOfficeAddressMapper on HeadOfficeAddress {
  HeadOfficeAddressEntity toEntity() {
    return HeadOfficeAddressEntity(
      city: city ?? '',
      regionState: regionState ?? '',
      country: country ?? '',
      id: id ?? '',
    );
  }
}
