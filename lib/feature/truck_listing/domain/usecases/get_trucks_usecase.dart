import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck_entity.dart';
import 'package:clean_architecture/feature/truck_listing/domain/models/truck_filter.dart';
import 'package:clean_architecture/feature/truck_listing/domain/repositories/truck_repository.dart';
import 'package:dartz/dartz.dart';

class GetTrucksUseCase extends UseCase<TruckBaseResponseEntity, TruckFilter> {
  final TruckRepository repository;

  GetTrucksUseCase(this.repository);

  @override
  Future<Either<Failure, TruckBaseResponseEntity>> call(
    TruckFilter params,
  ) async {
    return await repository.fetchTrucks(params);
  }
}
