import 'package:clean_architecture/feature/landing/data/model/featured_carrier_response.dart';

abstract class FeaturedCarrierRemoteDataSource {
  Future<FeaturedCarrierBaseResponse> getFeaturedCarriers();
}
