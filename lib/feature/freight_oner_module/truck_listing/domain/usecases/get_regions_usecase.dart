import 'package:dartz/dartz.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/regions_entity.dart';
import '../repositories/region_repository.dart';

class GetRegionsUseCase
    implements UseCase<RegionsBaseResponseEntity, NoParams> {
  final RegionRepository repository;

  GetRegionsUseCase(this.repository);

  @override
  Future<Either<Failure, RegionsBaseResponseEntity>> call(
    NoParams params,
  ) async {
    return await repository.getAllRegions();
  }
}
