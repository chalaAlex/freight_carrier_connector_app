import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/domain/repositories/truck_repository.dart';
import 'package:dartz/dartz.dart';

class GetTrucksUseCase extends UseCase<TruckBaseResponseEntity, int> {
  final TruckRepository repository;

  GetTrucksUseCase(this.repository);

  @override
  Future<Either<Failure, TruckBaseResponseEntity>> call(int page) async {
    print('GetTrucksUseCase called with page: $page');
    return await repository.fetchTrucks(page);
  }
}
