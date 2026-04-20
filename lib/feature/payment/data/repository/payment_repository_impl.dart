import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/payment/data/datasource/payment_remote_data_source.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/domain/repository/payment_repository.dart';
import 'package:dartz/dartz.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, InitiatePaymentEntity>> initiatePayment({
    required String bookingType,
    required String sourceId,
  }) async {
    try {
      final result = await remoteDataSource.initiatePayment(bookingType: bookingType, sourceId: sourceId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String paymentId) async {
    try {
      final result = await remoteDataSource.getPaymentStatus(paymentId);
      return Right(result.toEntity()!);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> releasePayment(String paymentId) async {
    try {
      final result = await remoteDataSource.releasePayment(paymentId);
      return Right(result.toEntity()!);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> disputePayment(String paymentId) async {
    try {
      final result = await remoteDataSource.disputePayment(paymentId);
      return Right(result.toEntity()!);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, WalletEntity>> getWallet() async {
    try {
      final result = await remoteDataSource.getWallet();
      return Right(result.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, WalletTransactionsResponseEntity>> getWalletTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getWalletTransactions(page: page, limit: limit);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> requestWithdrawal(double amount) async {
    try {
      final result = await remoteDataSource.requestWithdrawal(amount);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
