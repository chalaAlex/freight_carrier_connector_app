import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/cofig/mapper.dart';
import '../../domain/entities/feature_entity.dart';
import '../../domain/repositories/feature_repository.dart';
import '../datasources/feature_remote_data_source.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;

  FeatureRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, FeatureBaseResponseEntity>> getAllFeatures() async {
    try {
      final response = await remoteDataSource.getAllFeatures();
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
