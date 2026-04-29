import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/truck_detail_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';

abstract class TruckDetailRepository {
  Future<Either<Failure, TruckDetailBaseEntity>> getTruckDetail(String truckId);
}
