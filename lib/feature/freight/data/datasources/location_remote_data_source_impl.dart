import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/freight/data/datasources/location_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/model/location_model.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiClient client;

  LocationRemoteDataSourceImpl({required this.client});

  @override
  Future<LocationBaseResponse> getLocations({
    int? page,
    int? limit,
    String? search,
    String? region,
  }) async {
    return await client.getLocation(
      page: page,
      limit: limit,
      search: search,
      region: region,
    );
  }
}
