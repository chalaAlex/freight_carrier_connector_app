import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class GetPaymentByFreightUseCase implements UseCase<PaymentEntity, String> {
  final PaymentRepository repository;
  GetPaymentByFreightUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(String freightId) {
    return repository.getPaymentByFreight(freightId);
  }
}
