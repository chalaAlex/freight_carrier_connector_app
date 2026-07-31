import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../../domain/entities/cities_entity.dart';
import '../../domain/repositories/city_repository.dart';
import '../datasources/city_remote_data_source.dart';
import '../models/cities_model.dart';

class CityRepositoryImpl implements CityRepository {
  final CityRemoteDataSource remoteDataSource;

  CityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CitiesBaseResponseEntity>> getAllCities() async {
    try {
      final response = await remoteDataSource.getAllCities();
      final mapper = CitiesBaseResponseMapper();
      final entity = mapper.mapToEntity(response);
      return Right(entity);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
