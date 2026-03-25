import 'package:clean_architecture/core/request/review_request.dart';
import 'package:clean_architecture/feature/rating_and_review/data/model/completed_shipment_model.dart';
import 'package:clean_architecture/feature/rating_and_review/data/model/review_response_model.dart';
import 'package:dio/dio.dart';

import 'review_remote_data_source.dart';

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final Dio dio;

  ReviewRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CompletedShipmentModel>> getCompletedShipments() async {
    final response = await dio.get(
      '/shipmentRequests/sent',
      queryParameters: {'status': 'COMPLETED', 'isReviewed': 'false'},
    );
    final requests = (response.data['data']['requests'] as List<dynamic>);
    return requests
        .map((e) => CompletedShipmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReviewResponseModel> submitReview(SubmitReviewParams params) async {
    final response = await dio.post('/reviews', data: params.toJson());
    return ReviewResponseModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
