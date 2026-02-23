import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/entity/cargo_type_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/cargo_type_repository.dart';
import 'package:dartz/dartz.dart';

class GetCargoTypesUseCase
    implements UseCase<CargoTypeBaseResponseEntity, NoParams> {
  final CargoTypeRepository _repository;

  GetCargoTypesUseCase(this._repository);

  @override
  Future<Either<Failure, CargoTypeBaseResponseEntity>> call(
    NoParams params,
  ) async {
    return await _repository.getCargoTypes();
  }
}
