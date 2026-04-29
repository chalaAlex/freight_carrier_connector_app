import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentRepository {
  Future<Either<Failure, InitiatePaymentEntity>> initiatePayment({
    required String bookingType,
    required String sourceId,
  });

  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String paymentId);

  Future<Either<Failure, PaymentEntity>> releasePayment(String paymentId);

  Future<Either<Failure, PaymentEntity>> disputePayment(String paymentId);

  Future<Either<Failure, WalletEntity>> getWallet();

  Future<Either<Failure, WalletTransactionsResponseEntity>> getWalletTransactions({int page, int limit});

  Future<Either<Failure, Map<String, dynamic>>> requestWithdrawal(double amount);
}
