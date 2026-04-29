import 'package:clean_architecture/feature/payment/data/model/payment_model.dart';
import 'package:clean_architecture/feature/payment/data/datasource/payment_remote_data_source.dart';
import 'package:dio/dio.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;
  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<InitiatePaymentResponseModel> initiatePayment({
    required String bookingType,
    required String sourceId,
  }) async {
    final response = await dio.post(
      '/payments/initiate',
      data: {'bookingType': bookingType, 'sourceId': sourceId},
    );
    return InitiatePaymentResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaymentResponseModel> getPaymentStatus(String paymentId) async {
    final response = await dio.get('/payments/$paymentId');
    return PaymentResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaymentResponseModel> releasePayment(String paymentId) async {
    final response = await dio.post('/payments/$paymentId/release');
    return PaymentResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaymentResponseModel> disputePayment(String paymentId) async {
    final response = await dio.post('/payments/$paymentId/dispute');
    return PaymentResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WalletModel> getWallet() async {
    final response = await dio.get('/wallet');
    return WalletModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WalletTransactionsResponseModel> getWalletTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/wallet/transactions',
      queryParameters: {'page': page, 'limit': limit},
    );
    return WalletTransactionsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> requestWithdrawal(double amount) async {
    final response = await dio.post('/wallet/withdraw', data: {'amount': amount});
    return response.data as Map<String, dynamic>;
  }
}
