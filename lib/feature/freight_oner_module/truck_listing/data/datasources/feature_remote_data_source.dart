import '../models/feature_response.dart';

abstract class FeatureRemoteDataSource {
  Future<FeatureBaseResponse> getAllFeatures();
}
