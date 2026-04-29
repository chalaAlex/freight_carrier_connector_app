import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../../domain/entities/regions_entity.dart';
import '../../domain/repositories/region_repository.dart';
import '../datasources/region_remote_data_source.dart';
import '../models/regions_model.dart';

class RegionRepositoryImpl implements RegionRepository {
  final RegionRemoteDataSource remoteDataSource;

  RegionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, RegionsBaseResponseEntity>> getAllRegions() async {
    try {
      final response = await remoteDataSource.getAllRegions();
      final mapper = RegionsBaseResponseMapper();
      final entity = mapper.mapToEntity(response);
      return Right(entity);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
