import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/review_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/data/datasources/review_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/rating_and_review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CompletedShipmentEntity>>>
  getCompletedShipments() async {
    try {
      final models = await remoteDataSource.getCompletedShipments();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitReview(
    SubmitReviewParams params,
  ) async {
    try {
      final model = await remoteDataSource.submitReview(params);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
