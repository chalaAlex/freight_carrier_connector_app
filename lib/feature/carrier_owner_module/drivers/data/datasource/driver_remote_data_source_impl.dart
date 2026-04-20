import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/datasource/driver_remote_data_source.dart';
import 'package:dio/dio.dart';

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final ApiClient apiClient;
  final Dio dio;

  DriverRemoteDataSourceImpl({required this.apiClient, required this.dio});

  @override
  Future<Map<String, dynamic>> getMyDrivers() async {
    final result = await apiClient.getMyDrivers();
    return result as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getDriver(String id) async {
    final result = await apiClient.getDriver(id);
    return result as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createDriver(Map<String, dynamic> body) async {
    final result = await apiClient.createDriver(body);
    return result as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateDriver(
    String id,
    Map<String, dynamic> body,
  ) async {
    final result = await apiClient.updateDriver(id, body);
    return result as Map<String, dynamic>;
  }

  @override
  Future<void> deleteDriver(String id) => apiClient.deleteDriver(id);

  @override
  Future<void> assignDriver(String carrierId, String driverId) async {
    await dio.patch('/carrier/$carrierId/assign-driver/$driverId');
  }

  @override
  Future<void> unassignDriver(String carrierId, String driverId) async {
    await dio.patch('/carrier/$carrierId/remove-driver/$driverId');
  }
}
