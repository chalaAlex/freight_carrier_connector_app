import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/data/datasource/freights_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freights_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/repository/freights_repository.dart';
import 'package:dartz/dartz.dart';

class FreightsRepositoryImpl implements FreightsRepository {
  final FreightsRemoteDataSource remoteDataSource;

  FreightsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FreightsResponseEntity>> getFreights({
    int? page,
    int? limit,
    FreightFilter? filter,
  }) async {
    try {
      final response = await remoteDataSource.getFreights(
        page: page,
        limit: limit,
        filter: filter,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(
          Failure(
            response.statusCode ?? 0,
            response.message ?? 'Unknown error',
          ),
        );
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
