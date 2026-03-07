import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/freight/data/datasources/truck_detail_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/model/truck_detail_model.dart';

class TruckDetailRemoteDataSourceImpl implements TruckDetailRemoteDataSource {
  final ApiClient client;

  TruckDetailRemoteDataSourceImpl({required this.client});

  @override
  Future<TruckDetailBaseResponse> getTruckDetail(String truckId) async {
    return await client.getTruckDetail(truckId);
  }
}
