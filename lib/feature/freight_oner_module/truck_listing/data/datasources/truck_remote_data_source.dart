import '../models/truck_model.dart';

abstract class TruckRemoteDataSource {
  /// Fetches trucks using a flat map of query parameters built from [TruckFilter].
  Future<TruckBaseResponse> getTrucks(Map<String, dynamic> queryParams);
}
