abstract class DriverRemoteDataSource {
  Future<Map<String, dynamic>> getMyDrivers();
  Future<Map<String, dynamic>> getDriver(String id);
  Future<Map<String, dynamic>> createDriver(Map<String, dynamic> body);
  Future<Map<String, dynamic>> updateDriver(
    String id,
    Map<String, dynamic> body,
  );
  Future<void> deleteDriver(String id);
  Future<void> assignDriver(String carrierId, String driverId);
  Future<void> unassignDriver(String carrierId, String driverId);
}
