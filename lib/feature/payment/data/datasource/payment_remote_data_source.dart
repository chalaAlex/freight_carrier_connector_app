import 'package:clean_architecture/feature/payment/data/model/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<InitiatePaymentResponseModel> initiatePayment({
    required String bookingType,
    required String sourceId,
    required String gateway,
  });
  Future<PaymentResponseModel> confirmPayment({required String outTradeNo});
  Future<PaymentResponseModel> getPaymentByFreight(String freightId);
  Future<PaymentResponseModel> getPaymentStatus(String paymentId);
  Future<PaymentResponseModel> releasePayment(String paymentId);
  Future<PaymentResponseModel> disputePayment(String paymentId);
  Future<WalletModel> getWallet();
  Future<WalletTransactionsResponseModel> getWalletTransactions({
    int page,
    int limit,
  });
  Future<Map<String, dynamic>> requestWithdrawal(double amount);
}
