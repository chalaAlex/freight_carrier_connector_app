import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/data/model/sent_requests_response_model.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/data/model/shipment_request_response_model.dart';

abstract class ShipmentRequestRemoteDataSource {
  Future<RequestResponse> createShipmentRequest(CreateShipmentRequest request);
  Future<SentRequestsResponseModel> getSentRequests(String status);
  Future<void> cancelRequest(String id);
  Future<void> completeRequest(String id);
}
