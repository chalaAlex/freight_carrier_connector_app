import '../models/brand_response.dart';

abstract class BrandRemoteDataSource {
  Future<BrandBaseResponse> getAllBrands();
}
