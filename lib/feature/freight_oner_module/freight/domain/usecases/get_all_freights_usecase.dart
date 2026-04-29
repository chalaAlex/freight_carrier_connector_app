import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/entity/my_loads_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/freight_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllFreightsParams {
  final int page;
  final String? status;

  const GetAllFreightsParams({this.page = 1, this.status});
}

class GetAllFreightsUseCase {
  final FreightRepository repository;

  GetAllFreightsUseCase(this.repository);

  Future<Either<Failure, MyLoadsResponseEntity>> call(
    GetAllFreightsParams params,
  ) {
    return repository.getFreights(params.page, params.status);
  }
}
