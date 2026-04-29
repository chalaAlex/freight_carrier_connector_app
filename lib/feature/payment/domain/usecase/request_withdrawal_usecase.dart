import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class RequestWithdrawalUseCase implements UseCase<Map<String, dynamic>, double> {
  final PaymentRepository repository;
  RequestWithdrawalUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(double amount) {
    return repository.requestWithdrawal(amount);
  }
}
