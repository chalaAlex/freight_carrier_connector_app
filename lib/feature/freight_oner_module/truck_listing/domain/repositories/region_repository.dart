import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/regions_entity.dart';

abstract class RegionRepository {
  Future<Either<Failure, RegionsBaseResponseEntity>> getAllRegions();
}
