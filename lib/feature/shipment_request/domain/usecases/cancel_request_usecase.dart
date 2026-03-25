import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/shipment_request/domain/repositories/shipment_request_repository.dart';
import 'package:dartz/dartz.dart';

class CancelRequestUseCase {
  final ShipmentRequestRepository repository;
  CancelRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.cancelRequest(id);
}
