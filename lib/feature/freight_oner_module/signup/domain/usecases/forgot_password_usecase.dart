import 'package:clean_architecture/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/login_repository.dart';

class ForgotPasswordUseCase {
  final LoginRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
