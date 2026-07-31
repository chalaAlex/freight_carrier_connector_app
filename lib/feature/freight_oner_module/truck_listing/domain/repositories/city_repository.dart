import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/cities_entity.dart';

abstract class CityRepository {
  Future<Either<Failure, CitiesBaseResponseEntity>> getAllCities();
}
