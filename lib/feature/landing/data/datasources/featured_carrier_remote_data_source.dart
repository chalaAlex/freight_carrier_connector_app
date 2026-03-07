import 'package:clean_architecture/feature/landing/data/featured_carrier_response.dart';

abstract class FeaturedCarrierRemoteDataSource {
  Future<FeaturedCarrierBaseResponse> getFeaturedCarriers();
}
