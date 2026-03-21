import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/data/model/shipment_request_response_model.dart';
import 'package:clean_architecture/feature/shipment_request/data/datasources/shipment_request_remote_data_source.dart';

class ShipmentRequestRemoteDataSourceImpl
    implements ShipmentRequestRemoteDataSource {
  final ApiClient apiClient;

  ShipmentRequestRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RequestResponse> createShipmentRequest(
    CreateShipmentRequest request,
  ) async {
    return await apiClient.createShipmentRequest(request);
  }
}
