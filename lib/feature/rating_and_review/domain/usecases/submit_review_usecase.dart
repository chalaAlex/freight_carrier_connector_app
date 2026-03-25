import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/review_request.dart';
import 'package:clean_architecture/feature/rating_and_review/domain/entity/review_entity.dart';
import 'package:clean_architecture/feature/rating_and_review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class SubmitReviewUseCase implements UseCase<ReviewEntity, SubmitReviewParams> {
  final ReviewRepository repository;

  SubmitReviewUseCase(this.repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(SubmitReviewParams params) async {
    return repository.submitReview(params);
  }
}
