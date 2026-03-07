import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/landing/data/datasources/featured_carrier_remote_data_source.dart';
import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:clean_architecture/feature/landing/domain/repositories/featured_carrier_repository.dart';
import 'package:dartz/dartz.dart';

class FeaturedCarrierRepositoryImpl implements FeaturedCarrierRepository {
  final FeaturedCarrierRemoteDataSource remoteDataSource;

  FeaturedCarrierRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, FeaturedCarrierResponseEntity>>
  getFeaturedCarriers() async {
    try {
      final response = await remoteDataSource.getFeaturedCarriers();
      // TODO: Add proper status code check when API is ready
      final entity = FeaturedCarrierResponseEntity(
        status: response.status,
        results: response.results,
        data: FeaturedCarrierDataEntity(
          featuredCarrier: response.data.featuredCarrier
              .map((truck) => truck.toEntity())
              .toList(),
        ),
      );
      return Right(entity);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
