import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/data/datasources/featured_carrier_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/domain/entity/featured_carrier_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/domain/repositories/featured_carrier_repository.dart';
import 'package:dartz/dartz.dart';

class FeaturedCarrierRepositoryImpl implements FeaturedCarrierRepository {
  final FeaturedCarrierRemoteDataSource remoteDataSource;

  FeaturedCarrierRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, FeaturedCarrierResponseEntity>>
  getFeaturedCarriers() async {
    try {
      final response = await remoteDataSource.getFeaturedCarriers();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final entity = FeaturedCarrierResponseEntity(
          statusCode: response.statusCode,
          results: response.results,
          data: FeaturedCarrierDataEntity(
            featuredCarrier: response.data.featuredCarrier
                .map((truck) => truck.toEntity())
                .toList(),
          ),
        );
        return Right(entity);
      } else {
        return Left(Failure(response.statusCode, response.message));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
