import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/data/model/sent_requests_response_model.dart';
import 'package:clean_architecture/feature/shipment_request/data/model/shipment_request_response_model.dart';
import 'package:clean_architecture/feature/shipment_request/data/datasources/shipment_request_remote_data_source.dart';
import 'package:dio/dio.dart';

class ShipmentRequestRemoteDataSourceImpl implements ShipmentRequestRemoteDataSource {
  final ApiClient apiClient;
  final Dio dio;

  ShipmentRequestRemoteDataSourceImpl({
    required this.apiClient,
    required this.dio,
  });

  @override
  Future<RequestResponse> createShipmentRequest(
    CreateShipmentRequest request,
  ) async {
    return await apiClient.createShipmentRequest(request);
  }

  @override
  Future<SentRequestsResponseModel> getSentRequests(String status) async {
    final response = await dio.get(
      '/shipmentRequests/sent',
      queryParameters: {'status': status},
    );
    return SentRequestsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cancelRequest(String id) async {
    await dio.delete('/shipmentRequests/$id');
  }

  @override
  Future<void> completeRequest(String id) async {
    await dio.patch('/shipmentRequests/$id/complete');
  }
}
