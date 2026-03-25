import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/rating_and_review/domain/entity/review_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/request/review_request.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<CompletedShipmentEntity>>>
  getCompletedShipments();
  Future<Either<Failure, ReviewEntity>> submitReview(SubmitReviewParams params);
}
