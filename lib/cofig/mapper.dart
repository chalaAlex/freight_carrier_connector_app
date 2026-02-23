import 'package:clean_architecture/cofig/base_mapper.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_response_model.dart';
import 'package:clean_architecture/feature/freight/data/model/location_model.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_entity.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:clean_architecture/feature/signup/data/models/login_model.dart';
import 'package:clean_architecture/feature/signup/data/models/sign_up_model.dart';
import 'package:clean_architecture/feature/signup/domain/entities/login_entity.dart';
import 'package:clean_architecture/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';

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
      data: dto.data?.trucks?.map((e) => _dataMapper.mapToEntity(e)).toList(),
    );
  }
}

class TruckDataMapper extends BaseMapper<TruckDto, TruckDataEntity> {
  @override
  TruckDataEntity mapToEntity(TruckDto dto) {
    return TruckDataEntity(
      id: dto.id,
      model: dto.model,
      company: dto.company,
      pricePerDay: double.tryParse(dto.pricePerDay.toString()) ?? 0.0,
      pricePerHour: double.tryParse(dto.pricePerHour.toString()) ?? 0.0,
      capacityTons: double.tryParse(dto.capacityTons.toString()) ?? 0.0,
      carrierType: dto.carrierType,
      location: dto.location,
      radiusKm: double.tryParse(dto.radiusKm.toString()) ?? 0.0,
      imageUrl: dto.imageUrl,
      isAvailable: dto.isAvailable,
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
