import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String? outTradeNo;
  final String? bookingType;
  final String? sourceId;
  final String? freightId;
  final String? freightOwnerId;
  final String? carrierOwnerId;
  final double? totalAmount;
  final double? platformFee;
  final double? carrierAmount;
  final String? status;
  final DateTime? paidAt;
  final DateTime? releasedAt;
  final DateTime? releaseAt;

  const PaymentEntity({
    this.id, this.outTradeNo, this.bookingType, this.sourceId,
    this.freightId, this.freightOwnerId, this.carrierOwnerId,
    this.totalAmount, this.platformFee, this.carrierAmount,
    this.status, this.paidAt, this.releasedAt, this.releaseAt,
  });

  @override
  List<Object?> get props => [id, outTradeNo, status, totalAmount, platformFee, carrierAmount, paidAt, releasedAt, releaseAt];
}

class InitiatePaymentEntity extends Equatable {
  final PaymentEntity? payment;
  final String? toPayUrl;
  const InitiatePaymentEntity({this.payment, this.toPayUrl});
  @override
  List<Object?> get props => [payment, toPayUrl];
}

class WalletEntity extends Equatable {
  final String? id;
  final double? balance;
  final double? pendingBalance;
  final String? currency;
  const WalletEntity({this.id, this.balance, this.pendingBalance, this.currency});
  @override
  List<Object?> get props => [id, balance, pendingBalance, currency];
}

class WalletTransactionEntity extends Equatable {
  final String? id;
  final String? walletId;
  final String? paymentId;
  final String? type;
  final double? amount;
  final String? description;
  final DateTime? createdAt;
  const WalletTransactionEntity({this.id, this.walletId, this.paymentId, this.type, this.amount, this.description, this.createdAt});
  @override
  List<Object?> get props => [id, type, amount, createdAt];
}

class WalletTransactionsResponseEntity extends Equatable {
  final List<WalletTransactionEntity>? transactions;
  final int? total;
  final int? page;
  final int? limit;
  const WalletTransactionsResponseEntity({this.transactions, this.total, this.page, this.limit});
  @override
  List<Object?> get props => [transactions, total, page, limit];
}
