import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/repositories/shipment_request_repository.dart';
import 'package:dartz/dartz.dart';

class CreateShipmentRequestUseCase
    implements UseCase<RequestResponseEntity, CreateShipmentRequest> {
  final ShipmentRequestRepository repository;

  CreateShipmentRequestUseCase(this.repository);

  @override
  Future<Either<Failure, RequestResponseEntity>> call(
    CreateShipmentRequest params,
  ) {
    return repository.createShipmentRequest(params);
  }
}
