import 'package:clean_architecture/core/network/api_client.dart';
import '../models/feature_response.dart';
import 'feature_remote_data_source.dart';

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final ApiClient client;

  FeatureRemoteDataSourceImpl({required this.client});

  @override
  Future<FeatureBaseResponse> getAllFeatures() async {
    return await client.getAllFeatures();
  }
}
