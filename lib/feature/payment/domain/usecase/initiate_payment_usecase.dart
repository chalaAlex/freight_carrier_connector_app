import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class InitiatePaymentParams {
  final String bookingType;
  final String sourceId;
  const InitiatePaymentParams({required this.bookingType, required this.sourceId});
}

class InitiatePaymentUseCase implements UseCase<InitiatePaymentEntity, InitiatePaymentParams> {
  final PaymentRepository repository;
  InitiatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, InitiatePaymentEntity>> call(InitiatePaymentParams params) {
    return repository.initiatePayment(bookingType: params.bookingType, sourceId: params.sourceId);
  }
}
