import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/data/datasources/truck_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/entities/truck_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/models/truck_filter.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/repositories/truck_repository.dart';
import 'package:dartz/dartz.dart';

class TruckRepositoryImpl implements TruckRepository {
  final TruckRemoteDataSource remoteDataSource;

  TruckRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TruckBaseResponseEntity>> fetchTrucks(
    TruckFilter filter,
  ) async {
    try {
      final response = await remoteDataSource.getTrucks(filter.toQueryParams());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(TruckResponseMapper().mapToEntity(response));
      } else {
        return Left(Failure(response.statusCode!, response.message!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
