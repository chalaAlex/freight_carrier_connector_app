import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/freight/data/datasources/cargo_type_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/model/cargo_type_model.dart';

class CargoTypeRemoteDataSourceImpl implements CargoTypeRemoteDataSource {
  final ApiClient _apiClient;

  CargoTypeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CargoTypeBaseResponse> getCargoTypes() async {
    return await _apiClient.getCargoTypes();
  }
}
