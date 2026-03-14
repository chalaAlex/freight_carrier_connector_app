import 'package:clean_architecture/core/network/api_client.dart';
import '../models/regions_model.dart';
import 'region_remote_data_source.dart';

class RegionRemoteDataSourceImpl implements RegionRemoteDataSource {
  final ApiClient client;

  RegionRemoteDataSourceImpl({required this.client});

  @override
  Future<RegionsBaseResponse> getAllRegions() async {
    return await client.getAllRegions();
  }
}
