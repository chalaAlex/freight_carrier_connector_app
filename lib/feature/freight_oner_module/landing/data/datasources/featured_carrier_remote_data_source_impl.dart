import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/data/datasources/featured_carrier_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/landing/data/model/featured_carrier_response.dart';

class FeaturedCarrierRemoteDataSourceImpl
    implements FeaturedCarrierRemoteDataSource {
  final ApiClient _apiClient;

  FeaturedCarrierRemoteDataSourceImpl(this._apiClient);

  @override
  Future<FeaturedCarrierBaseResponse> getFeaturedCarriers() async {
    return await _apiClient.getFeaturedCarriers();
  }
}
