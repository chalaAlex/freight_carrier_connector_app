import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:clean_architecture/core/request/sign_up_request.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/sign_up_repository.dart';
import '../datasources/sign_up_remote_data_source.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpRemoteDataSource signUpRemoteDataSource;

  SignUpRepositoryImpl(this.signUpRemoteDataSource);

  @override
  Future<Either<Failure, SignUpBaseResponseEntity>> signUp(
    SignUpRequest signUpRequest,
  ) async {
    try {
      final response = await signUpRemoteDataSource.signUp(signUpRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(SignUpResponseMapper().mapToEntity(response));
      } else {
        return Left(Failure(response.statusCode!, response.message!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
