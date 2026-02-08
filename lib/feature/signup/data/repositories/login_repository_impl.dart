import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/signup/data/datasources/login_remote_data_source.dart';
import 'package:clean_architecture/feature/signup/domain/entities/login_entity.dart';
import 'package:clean_architecture/feature/signup/domain/repositories/login_repository.dart';
import 'package:clean_architecture/core/request/login_request.dart';
import 'package:dartz/dartz.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImpl(this.loginRemoteDataSource);

  @override
  Future<Either<Failure, LoginBaseResponseEntity>> login(
    LoginRequest loginRequest,
  ) async {
    try {
      final response = await loginRemoteDataSource.login(loginRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(LoginResponseMapper().mapToEntity(response));
      } else {
        return Left(Failure(response.statusCode!, response.token!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
