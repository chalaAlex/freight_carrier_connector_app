import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/data/datasources/location_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/location_repository.dart';
import 'package:clean_architecture/cofig/mapper.dart';
import 'package:dartz/dartz.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, RegionBaseResponseEntity>> getLocations({
    int? page,
    int? limit,
    String? search,
    String? region,
  }) async {
    try {
      final response = await remoteDataSource.getLocations(
        page: page,
        limit: limit,
        search: search,
        region: region,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(Failure(response.statusCode!, response.message!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
