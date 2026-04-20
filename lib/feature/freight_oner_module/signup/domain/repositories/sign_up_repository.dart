import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/sign_up_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/entities/sign_up_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SignUpRepository {
  Future<Either<Failure, SignUpBaseResponseEntity>> signUp(SignUpRequest signUpRequst);
}
