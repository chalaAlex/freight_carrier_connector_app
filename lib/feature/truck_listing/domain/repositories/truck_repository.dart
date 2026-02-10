import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:dartz/dartz.dart';

abstract class TruckRepository {
  Future<Either<Failure, TruckBaseResponseEntity>> fetchTrucks(int page);
}