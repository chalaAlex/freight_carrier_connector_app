import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:clean_architecture/core/request/sign_up_request.dart';
import 'package:dartz/dartz.dart';
import '../repositories/sign_up_repository.dart';

class SignUpUsecase {
  final SignUpRepository signUpRepository;

  SignUpUsecase(this.signUpRepository);

  Future<Either<Failure, SignUpBaseResponseEntity>> call(SignUpUseCaseInput input,) async {
    return await signUpRepository.signUp(SignUpRequest(
      input.firstName,
      input.lastName,
      input.email,
      input.phone,
      input.password,
      input.confirmPassword,
      input.role,
    ));
  }
}

class SignUpUseCaseInput {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String role;

  SignUpUseCaseInput(
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.confirmPassword,
    this.role,
  );
}
