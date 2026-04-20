import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/entities/login_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/repositories/login_repository.dart';
import 'package:clean_architecture/core/request/login_request.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase {
  final LoginRepository loginRepository;

  LoginUsecase(this.loginRepository);

  Future<Either<Failure, LoginBaseResponseEntity>> call(
    LoginUseCaseInput input,
  ) async {
    return await loginRepository.login(
      LoginRequest(email: input.email, password: input.password),
    );
  }
}

class LoginUseCaseInput {
  final String email;
  final String password;

  LoginUseCaseInput(this.email, this.password);
}
