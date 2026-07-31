import 'package:clean_architecture/core/network/api_client.dart';
import '../models/cities_model.dart';
import 'city_remote_data_source.dart';

class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  final ApiClient client;

  CityRemoteDataSourceImpl({required this.client});

  @override
  Future<CitiesBaseResponse> getAllCities() async {
    return await client.getAllCities();
  }
}
