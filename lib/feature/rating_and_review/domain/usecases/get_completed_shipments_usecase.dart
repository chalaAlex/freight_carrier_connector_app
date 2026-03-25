import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/rating_and_review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class GetCompletedShipmentsUseCase
    implements UseCase<List<CompletedShipmentEntity>, NoParams> {
  final ReviewRepository repository;

  GetCompletedShipmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CompletedShipmentEntity>>> call(
    NoParams params,
  ) async {
    return repository.getCompletedShipments();
  }
}
