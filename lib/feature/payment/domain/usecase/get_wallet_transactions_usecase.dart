import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class GetWalletTransactionsParams {
  final int page;
  final int limit;
  const GetWalletTransactionsParams({this.page = 1, this.limit = 20});
}

class GetWalletTransactionsUseCase implements UseCase<WalletTransactionsResponseEntity, GetWalletTransactionsParams> {
  final PaymentRepository repository;
  GetWalletTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, WalletTransactionsResponseEntity>> call(GetWalletTransactionsParams params) {
    return repository.getWalletTransactions(page: params.page, limit: params.limit);
  }
}
