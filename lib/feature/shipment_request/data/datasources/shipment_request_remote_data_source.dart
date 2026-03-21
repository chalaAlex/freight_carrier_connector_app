import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/data/model/shipment_request_response_model.dart';

abstract class ShipmentRequestRemoteDataSource {
  Future<RequestResponse> createShipmentRequest(CreateShipmentRequest request);
}
