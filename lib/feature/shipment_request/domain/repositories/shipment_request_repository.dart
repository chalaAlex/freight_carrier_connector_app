import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ShipmentRequestRepository {
  Future<Either<Failure, RequestResponseEntity>> createShipmentRequest(
    CreateShipmentRequest request,
  );

  Future<Either<Failure, List<SentRequestEntity>>> getSentRequests(
    String status,
  );

  Future<Either<Failure, void>> cancelRequest(String id);
  Future<Either<Failure, void>> completeRequest(String id);
}
