import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/truck_listing/data/datasources/truck_remote_data_source.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';

class TruckRemoteDataSourceImpl implements TruckRemoteDataSource {
  final ApiClient client;

  TruckRemoteDataSourceImpl({required this.client});

  @override
  Future<TruckBaseResponse> getTrucks(int page) async {
    return await client.getTrucks(page: page, limit: 10);
  }
}
