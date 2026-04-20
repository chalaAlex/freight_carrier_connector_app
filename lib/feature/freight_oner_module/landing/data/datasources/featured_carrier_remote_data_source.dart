import 'package:clean_architecture/feature/freight_oner_module/landing/data/model/featured_carrier_response.dart';

abstract class FeaturedCarrierRemoteDataSource {
  Future<FeaturedCarrierBaseResponse> getFeaturedCarriers();
}
