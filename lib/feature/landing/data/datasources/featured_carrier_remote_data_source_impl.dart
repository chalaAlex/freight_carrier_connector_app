import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/landing/data/datasources/featured_carrier_remote_data_source.dart';
import 'package:clean_architecture/feature/landing/data/featured_carrier_response.dart';

class FeaturedCarrierRemoteDataSourceImpl
    implements FeaturedCarrierRemoteDataSource {
  final ApiClient client;

  FeaturedCarrierRemoteDataSourceImpl({required this.client});

  @override
  Future<FeaturedCarrierBaseResponse> getFeaturedCarriers() async {
    return await client.getFeaturedCarriers();
  }
}
