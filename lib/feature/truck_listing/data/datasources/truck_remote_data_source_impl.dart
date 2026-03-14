import 'package:clean_architecture/feature/truck_listing/data/datasources/truck_remote_data_source.dart';
import 'package:clean_architecture/feature/truck_listing/data/models/truck_model.dart';
import 'package:dio/dio.dart';

class TruckRemoteDataSourceImpl implements TruckRemoteDataSource {
  final Dio dio;

  TruckRemoteDataSourceImpl({required this.dio});

  @override
  Future<TruckBaseResponse> getTrucks(Map<String, dynamic> queryParams) async {
    // Remove null values before sending
    queryParams.removeWhere((_, v) => v == null);
    final response = await dio.get('/carrier', queryParameters: queryParams);
    return TruckBaseResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
