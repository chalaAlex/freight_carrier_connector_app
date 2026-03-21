import 'package:clean_architecture/cofig/base_mapper.dart';
import 'package:clean_architecture/feature/company/data/model/company_response.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';
import 'package:clean_architecture/feature/freight/data/model/cargo_type_model.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_detail_model.dart';
import 'package:clean_architecture/feature/freight/data/model/location_model.dart';
import 'package:clean_architecture/feature/freight/data/model/truck_detail_model.dart'
    as detail;
import 'package:clean_architecture/feature/freight/domain/entity/freight_detail_entity.dart';
import 'package:clean_architecture/feature/landing/domain/entity/freight_detail_entiry.dart';
import 'package:clean_architecture/feature/my_loads/data/model/my_loads_base_response_model.dart'
    as freight_model;
import 'package:clean_architecture/feature/freight/domain/entity/cargo_type_entity.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart'
    as detail_entity;
import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart'
    as freight_entity;
import 'package:clean_architecture/feature/landing/data/model/featured_carrier_response.dart';
import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:clean_architecture/feature/signup/data/models/login_model.dart';
import 'package:clean_architecture/feature/signup/data/models/sign_up_model.dart';
import 'package:clean_architecture/feature/signup/domain/entities/login_entity.dart';
import 'package:clean_architecture/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/regions_model.dart'
    as regions_model;
import 'package:clean_architecture/feature/truck_listing/data/models/feature_response.dart'
    as feature_model;
import 'package:clean_architecture/feature/truck_listing/data/models/brand_response.dart'
    as brand_model;
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck_entity.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/regions_entity.dart'
    as regions_entity;
import 'package:clean_architecture/feature/truck_listing/domain/entities/feature_entity.dart'
    as feature_entity;
import 'package:clean_architecture/feature/truck_listing/domain/entities/brand_entity.dart'
    as brand_entity;
import 'package:clean_architecture/feature/shipment_request/data/model/shipment_request_response_model.dart'
    as shipment_model;
import 'package:clean_architecture/feature/shipment_request/domain/entity/shipment_request_entity.dart'
    as shipment_entity;

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
      pricePerKm: dto.pricePerKm != null
          ? double.tryParse(dto.pricePerKm.toString()) ?? 0.0
          : 0.0,
      loadCapacity: double.tryParse(dto.loadCapacity.toString()) ?? 0.0,
      features: dto.features,
      location: dto.location, // Now uses the getter from TruckDto
      radiusKm: dto.radiusKm != null
          ? double.tryParse(dto.radiusKm.toString()) ?? 0.0
          : 0.0,
      images: dto.image,
      isAvailable: dto.isAvailable,
      isVerified: dto.isVerified,
      createdAt: dto.createdAt != null
          ? DateTime.tryParse(dto.createdAt!)
          : null,
      updatedAt: dto.updatedAt != null
          ? DateTime.tryParse(dto.updatedAt!)
          : null,
    );
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
      data: data?.map((e) => RegionDtoMapper(e).toEntity()).toList(),
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
      data: data?.map((e) => CargoTypeDtoMapper(e).toEntity()).toList(),
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

// Regions response mapper.
extension TruckListingRegionDtoMapper on regions_model.RegionDto {
  regions_entity.RegionEntity toEntity() {
    return regions_entity.RegionEntity(
      id: id,
      name: name,
      country: country,
      isActive: isActive,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}

extension TruckListingRegionsBaseResponseMapper
    on regions_model.RegionsBaseResponse {
  regions_entity.RegionsBaseResponseEntity toEntity() {
    return regions_entity.RegionsBaseResponseEntity(
      statusCode: statusCode,
      message: message,
      total: total,
      regions: data?.regions?.map((region) => region.toEntity()).toList(),
    );
  }
}

// Feature response mapper.
extension FeatureDtoMapper on feature_model.Feature {
  feature_entity.FeatureEntity toEntity() {
    return feature_entity.FeatureEntity(
      id: id ?? '',
      name: name ?? '',
      icon: icon ?? '',
      description: description ?? '',
      isActive: isActive ?? false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension FeatureBaseResponseMapper on feature_model.FeatureBaseResponse {
  feature_entity.FeatureBaseResponseEntity toEntity() {
    return feature_entity.FeatureBaseResponseEntity(
      statusCode: statusCode,
      message: message,
      total: total,
      features: data?.features?.map((feature) => feature.toEntity()).toList(),
    );
  }
}

extension BrandDtoMapper on brand_model.Brand {
  brand_entity.BrandEntity toEntity() {
    return brand_entity.BrandEntity(
      id: id ?? '',
      name: name ?? '',
      description: description ?? '',
      isActive: isActive ?? false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension BrandBaseResponseMapper on brand_model.BrandBaseResponse {
  brand_entity.BrandBaseResponseEntity toEntity() {
    return brand_entity.BrandBaseResponseEntity(
      statusCode: statusCode,
      message: message,
      total: total,
      brands: data?.brands?.map((brand) => (brand).toEntity()).toList(),
    );
  }
}

// Myloads mapper
extension MyLoadsBaseResponseMapper on freight_model.MyLoadsBaseResponseModel {
  freight_entity.MyLoadsResponseEntity toEntity() {
    return freight_entity.MyLoadsResponseEntity(
      statusCode: statusCode,
      message: message,
      total: total,
      freights: freights?.map((freight) => freight.toEntity()).toList(),
    );
  }
}

extension MyLoadsMapper on freight_model.FreightModel {
  freight_entity.MyLoadsEntity toEntity() {
    return freight_entity.MyLoadsEntity(
      id: id,
      freightOwnerId: freightOwnerId,
      cargo: cargo?.toEntity(),
      route: route?.toEntity(),
      schedule: schedule?.toEntity(),
      truckRequirement: truckRequirement?.toEntity(),
      pricing: pricing?.toEntity(),
      status: status,
      images: image,
      bidCount: bidCount,
      isAvailable: isAvailable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CargoMapper on freight_model.CargoModel {
  freight_entity.CargoEntity toEntity() {
    return freight_entity.CargoEntity(
      type: type,
      description: description,
      weightKg: weightKg,
      quantity: quantity,
    );
  }
}

extension RouteMapper on freight_model.RouteModel {
  freight_entity.RouteEntity toEntity() {
    return freight_entity.RouteEntity(
      pickup: pickup?.toEntity(),
      dropoff: dropoff?.toEntity(),
    );
  }
}

extension LocationMapper on freight_model.LocationModel {
  freight_entity.LocationEntity toEntity() {
    return freight_entity.LocationEntity(
      region: region,
      city: city,
      address: address,
    );
  }
}

extension ScheduleMapper on freight_model.ScheduleModel {
  freight_entity.ScheduleEntity toEntity() {
    return freight_entity.ScheduleEntity(
      pickupDate: pickupDate,
      deliveryDeadline: deliveryDeadline,
    );
  }
}

extension TruckRequirementMapper on freight_model.TruckRequirementModel {
  freight_entity.TruckRequirementEntity toEntity() {
    return freight_entity.TruckRequirementEntity(
      type: type,
      minCapacityKg: minCapacityKg,
    );
  }
}

extension PricingMapper on freight_model.PricingModel {
  freight_entity.PricingEntity toEntity() {
    return freight_entity.PricingEntity(type: type, amount: amount);
  }
}

// Mapper for freight detail_entity and freight_model
extension FreightEntityMapper on FreightEntity {
  Freight toModel() {
    return Freight(
      id: id,
      freightOwnerId: freightOwnerId,
      cargo: cargo.toModel(),
      route: route.toModel(),
      schedule: schedule.toModel(),
      truckRequirement: truckRequirement.toModel(),
      pricing: pricing.toModel(),
      status: status,
      image: image,
      bidCount: bidCount,
      isAvailable: isAvailable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CargoEntityMapper on CargoEntity {
  Cargo toModel() {
    return Cargo(
      type: type,
      description: description,
      weightKg: weightKg,
      quantity: quantity,
    );
  }
}

extension RouteEntityMapper on RouteEntity {
  Route toModel() {
    return Route(pickup: pickup.toModel(), dropoff: dropoff.toModel());
  }
}

extension LocationEntityMapper on LocationEntity {
  Location toModel() {
    return Location(region: region, city: city, address: address);
  }
}

extension ScheduleEntityMapper on ScheduleEntity {
  Schedule toModel() {
    return Schedule(pickupDate: pickupDate, deliveryDeadline: deliveryDeadline);
  }
}

extension TruckRequirementEntityMapper on TruckRequirementEntity {
  TruckRequirement toModel() {
    return TruckRequirement(type: type, minCapacityKg: minCapacityKg);
  }
}

extension PricingEntityMapper on PricingEntity {
  Pricing toModel() {
    return Pricing(type: type, amount: amount);
  }
}

// FreightResponse → FreightDetailResponseEntity mapper
extension FreightResponseMapper on FreightDetailBaseResponse {
  FreightDetailResponseEntity toDetailEntity() {
    return FreightDetailResponseEntity(
      statusCode: statusCode,
      message: message,
      freight: data?.freight?.toDetailEntity(),
    );
  }
}

extension FreightToDetailEntityMapper on Freight {
  FreightDetailEntity toDetailEntity() {
    return FreightDetailEntity(
      id: id,
      freightOwnerId: freightOwnerId,
      cargo: cargo.toDetailEntity(),
      route: route.toDetailEntity(),
      schedule: schedule.toDetailEntity(),
      truckRequirement: truckRequirement.toDetailEntity(),
      pricing: pricing.toDetailEntity(),
      status: status,
      image: image,
      bidCount: bidCount,
      isAvailable: isAvailable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CargoToDetailEntityMapper on Cargo {
  FreightDetailCargoEntity toDetailEntity() {
    return FreightDetailCargoEntity(
      type: type,
      description: description,
      weightKg: weightKg,
      quantity: quantity,
    );
  }
}

extension RouteToDetailEntityMapper on Route {
  FreightDetailRouteEntity toDetailEntity() {
    return FreightDetailRouteEntity(
      pickup: pickup.toDetailEntity(),
      dropoff: dropoff.toDetailEntity(),
    );
  }
}

extension LocationToDetailEntityMapper on Location {
  FreightDetailLocationEntity toDetailEntity() {
    return FreightDetailLocationEntity(
      region: region ?? '',
      city: city ?? '',
      address: address ?? '',
    );
  }
}

extension ScheduleToDetailEntityMapper on Schedule {
  FreightDetailScheduleEntity toDetailEntity() {
    return FreightDetailScheduleEntity(
      pickupDate: pickupDate,
      deliveryDeadline: deliveryDeadline,
    );
  }
}

extension TruckRequirementToDetailEntityMapper on TruckRequirement {
  FreightDetailTruckRequirementEntity toDetailEntity() {
    return FreightDetailTruckRequirementEntity(
      type: type,
      minCapacityKg: minCapacityKg,
    );
  }
}

extension PricingToDetailEntityMapper on Pricing {
  FreightDetailPricingEntity toDetailEntity() {
    return FreightDetailPricingEntity(type: type, amount: amount);
  }
}

// Shipment request mapper
extension ShipmentRequestResponseMapper on shipment_model.RequestResponse {
  shipment_entity.RequestResponseEntity toEntity() {
    return shipment_entity.RequestResponseEntity(
      statusCode: statusCode,
      message: message,
      data: ShipmentRequestDataMapper(data).toEntity(),
    );
  }
}

extension ShipmentRequestDataMapper on shipment_model.RequestData {
  shipment_entity.RequestDataEntity toEntity() {
    return shipment_entity.RequestDataEntity(
      shipmentRequest: ShipmentRequestMapper(shipmentRequest).toEntity(),
    );
  }
}

extension ShipmentRequestMapper on shipment_model.ShipmentRequestModel {
  shipment_entity.ShipmentRequestEntity toEntity() {
    return shipment_entity.ShipmentRequestEntity(
      freightOwnerId: freightOwnerId,
      carrierOwnerId: carrierOwnerId,
      carrierId: carrierId,
      freightIds: freightIds,
      status: status,
      freightSnapshots: freightSnapshots
          .map((s) => FreightSnapshotMapper(s).toEntity())
          .toList(),
      proposedPrice: proposedPrice,
      freightOwnerContact: FreightOwnerContactMapper(
        freightOwnerContact,
      ).toEntity(),
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
    );
  }
}

extension FreightSnapshotMapper on shipment_model.FreightSnapshot {
  shipment_entity.FreightSnapshotEntity toEntity() {
    return shipment_entity.FreightSnapshotEntity(
      freightId: freightId,
      cargoType: cargoType,
      weight: weight,
      quantity: quantity,
      pickupLocation: ShipmentLocationMapper(pickupLocation).toEntity(),
      deliveryLocation: ShipmentLocationMapper(deliveryLocation).toEntity(),
      pickupDate: pickupDate,
      deliveryDate: deliveryDate,
      specialRequirements: specialRequirements,
    );
  }
}

extension ShipmentLocationMapper on shipment_model.SnapshotLocation {
  shipment_entity.LocationEntity toEntity() {
    return shipment_entity.LocationEntity(
      region: region,
      city: city,
      address: address,
    );
  }
}

extension FreightOwnerContactMapper on shipment_model.FreightOwnerContact {
  shipment_entity.FreightOwnerContactEntity toEntity() {
    return shipment_entity.FreightOwnerContactEntity(
      name: name,
      companyName: companyName,
      email: email,
      phone: phone,
    );
  }
}
