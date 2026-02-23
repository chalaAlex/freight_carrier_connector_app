import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LocationRepository {
  Future<Either<Failure, RegionBaseResponseEntity>> getLocations({
    int? page,
    int? limit,
    String? search,
    String? region,
  });
}
