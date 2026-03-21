import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ShipmentRequestRepository {
  Future<Either<Failure, RequestResponseEntity>> createShipmentRequest(
    CreateShipmentRequest request,
  );
}
