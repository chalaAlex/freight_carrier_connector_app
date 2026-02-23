import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/entity/cargo_type_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CargoTypeRepository {
  Future<Either<Failure, CargoTypeBaseResponseEntity>> getCargoTypes();
}
