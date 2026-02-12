import '../models/truck_model.dart';

abstract class TruckRemoteDataSource {
  Future<TruckBaseResponse> getTrucks(
    int page, {
    String? search,
    String? company,
    bool? isAvailable,
    String? carrierType,
  });
}