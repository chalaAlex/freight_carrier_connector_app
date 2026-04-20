import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class GetWalletUseCase implements UseCase<WalletEntity, NoParams> {
  final PaymentRepository repository;
  GetWalletUseCase(this.repository);

  @override
  Future<Either<Failure, WalletEntity>> call(NoParams params) {
    return repository.getWallet();
  }
}
