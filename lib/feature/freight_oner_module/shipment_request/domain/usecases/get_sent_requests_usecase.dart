import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/repositories/shipment_request_repository.dart';
import 'package:dartz/dartz.dart';

class GetSentRequestsUseCase {
  final ShipmentRequestRepository repository;

  GetSentRequestsUseCase(this.repository);

  Future<Either<Failure, List<SentRequestEntity>>> call(String status) {
    return repository.getSentRequests(status);
  }
}
