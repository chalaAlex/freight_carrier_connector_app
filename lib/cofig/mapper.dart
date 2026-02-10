import 'package:clean_architecture/cofig/base_mapper.dart';
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
      type: dto.type,
      location: dto.location,
      radiusKm: double.tryParse(dto.radiusKm.toString()) ?? 0.0,
      imageUrl: dto.imageUrl,
      isAvailable: dto.isAvailable,
    );
  }
}
