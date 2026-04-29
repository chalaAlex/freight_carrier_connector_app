import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freights_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FreightsRepository {
  Future<Either<Failure, FreightsResponseEntity>> getFreights({
    int? page,
    int? limit,
    FreightFilter? filter,
  });
}
