import 'package:clean_architecture/core/request/review_request.dart';
import 'package:clean_architecture/feature/rating_and_review/data/model/completed_shipment_model.dart';
import 'package:clean_architecture/feature/rating_and_review/data/model/review_response_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<CompletedShipmentModel>> getCompletedShipments();
  Future<ReviewResponseModel> submitReview(SubmitReviewParams params);
}
