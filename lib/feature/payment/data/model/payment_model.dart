import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';

class PaymentModel {
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

  PaymentModel({
    this.id, this.outTradeNo, this.bookingType, this.sourceId,
    this.freightId, this.freightOwnerId, this.carrierOwnerId,
    this.totalAmount, this.platformFee, this.carrierAmount,
    this.status, this.paidAt, this.releasedAt, this.releaseAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] as String?,
      outTradeNo: json['outTradeNo'] as String?,
      bookingType: json['bookingType'] as String?,
      sourceId: json['sourceId'] as String?,
      freightId: json['freightId'] as String?,
      freightOwnerId: json['freightOwnerId'] as String?,
      carrierOwnerId: json['carrierOwnerId'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      platformFee: (json['platformFee'] as num?)?.toDouble(),
      carrierAmount: (json['carrierAmount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      paidAt: json['paidAt'] != null ? DateTime.tryParse(json['paidAt']) : null,
      releasedAt: json['releasedAt'] != null ? DateTime.tryParse(json['releasedAt']) : null,
      releaseAt: json['releaseAt'] != null ? DateTime.tryParse(json['releaseAt']) : null,
    );
  }

  PaymentEntity toEntity() => PaymentEntity(
    id: id, outTradeNo: outTradeNo, bookingType: bookingType,
    sourceId: sourceId, freightId: freightId, freightOwnerId: freightOwnerId,
    carrierOwnerId: carrierOwnerId, totalAmount: totalAmount,
    platformFee: platformFee, carrierAmount: carrierAmount,
    status: status, paidAt: paidAt, releasedAt: releasedAt, releaseAt: releaseAt,
  );
}

class InitiatePaymentResponseModel {
  final PaymentModel? payment;
  final String? toPayUrl;

  InitiatePaymentResponseModel({this.payment, this.toPayUrl});

  factory InitiatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return InitiatePaymentResponseModel(
      payment: data?['payment'] != null
          ? PaymentModel.fromJson(data!['payment'] as Map<String, dynamic>)
          : null,
      toPayUrl: data?['toPayUrl'] as String?,
    );
  }

  InitiatePaymentEntity toEntity() => InitiatePaymentEntity(
    payment: payment?.toEntity(),
    toPayUrl: toPayUrl,
  );
}

class PaymentResponseModel {
  final PaymentModel? payment;

  PaymentResponseModel({this.payment});

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return PaymentResponseModel(
      payment: data?['payment'] != null
          ? PaymentModel.fromJson(data!['payment'] as Map<String, dynamic>)
          : null,
    );
  }

  PaymentEntity? toEntity() => payment?.toEntity();
}

class WalletModel {
  final String? id;
  final double? balance;
  final double? pendingBalance;
  final String? currency;

  WalletModel({this.id, this.balance, this.pendingBalance, this.currency});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final w = data?['wallet'] as Map<String, dynamic>? ?? data ?? json;
    return WalletModel(
      id: w['_id'] as String?,
      balance: (w['balance'] as num?)?.toDouble(),
      pendingBalance: (w['pendingBalance'] as num?)?.toDouble(),
      currency: w['currency'] as String?,
    );
  }

  WalletEntity toEntity() => WalletEntity(
    id: id, balance: balance, pendingBalance: pendingBalance, currency: currency,
  );
}

class WalletTransactionModel {
  final String? id;
  final String? walletId;
  final String? paymentId;
  final String? type;
  final double? amount;
  final String? description;
  final DateTime? createdAt;

  WalletTransactionModel({this.id, this.walletId, this.paymentId, this.type, this.amount, this.description, this.createdAt});

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['_id'] as String?,
      walletId: json['walletId'] as String?,
      paymentId: json['paymentId'] as String?,
      type: json['type'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  WalletTransactionEntity toEntity() => WalletTransactionEntity(
    id: id, walletId: walletId, paymentId: paymentId,
    type: type, amount: amount, description: description, createdAt: createdAt,
  );
}

class WalletTransactionsResponseModel {
  final List<WalletTransactionModel>? transactions;
  final int? total;
  final int? page;
  final int? limit;

  WalletTransactionsResponseModel({this.transactions, this.total, this.page, this.limit});

  factory WalletTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final rawList = data?['transactions'] as List<dynamic>?;
    return WalletTransactionsResponseModel(
      transactions: rawList?.map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: data?['total'] as int?,
      page: data?['page'] as int?,
      limit: data?['limit'] as int?,
    );
  }

  WalletTransactionsResponseEntity toEntity() => WalletTransactionsResponseEntity(
    transactions: transactions?.map((t) => t.toEntity()).toList(),
    total: total, page: page, limit: limit,
  );
}
