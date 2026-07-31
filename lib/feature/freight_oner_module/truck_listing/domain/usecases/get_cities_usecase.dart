import 'package:dartz/dartz.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/cities_entity.dart';
import '../repositories/city_repository.dart';

class GetCitiesUseCase implements UseCase<CitiesBaseResponseEntity, NoParams> {
  final CityRepository repository;

  GetCitiesUseCase(this.repository);

  @override
  Future<Either<Failure, CitiesBaseResponseEntity>> call(
    NoParams params,
  ) async {
    return await repository.getAllCities();
  }
}
