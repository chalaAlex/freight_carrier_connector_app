import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/my_loads/data/model/my_loads_base_response_model.dart';
import 'package:clean_architecture/feature/my_loads/data/datasources/my_loads_remote_data_source.dart';

class MyLoadsRemoteDataSourceImpl implements MyLoadsRemoteDataSource {
  final ApiClient apiClient;

  MyLoadsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MyLoadsBaseResponseModel> getMyLoads(String status) async {
    return await apiClient.getMyFreight(status: status);
  }
}
