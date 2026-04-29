import 'package:clean_architecture/core/network/api_client.dart';
import '../models/brand_response.dart';
import 'brand_remote_data_source.dart';

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final ApiClient client;

  BrandRemoteDataSourceImpl({required this.client});

  @override
  Future<BrandBaseResponse> getAllBrands() async {
    return await client.getAllBrands();
  }
}
