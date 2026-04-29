
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/entities/login_entity.dart';
import 'package:clean_architecture/core/request/login_request.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginBaseResponseEntity>> login(LoginRequest loginRequest);
}
