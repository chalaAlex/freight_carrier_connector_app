import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/data/datasources/truck_detail_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/truck_detail_repository.dart';
import 'package:dartz/dartz.dart';

class TruckDetailRepositoryImpl implements TruckDetailRepository {
  final TruckDetailRemoteDataSource remoteDataSource;

  TruckDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TruckDetailBaseEntity>> getTruckDetail(
    String truckId,
  ) async {
    try {
      final response = await remoteDataSource.getTruckDetail(truckId);
      return Right(response.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
