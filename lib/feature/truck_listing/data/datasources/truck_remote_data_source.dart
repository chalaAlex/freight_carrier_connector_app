import '../models/truck_model.dart';

abstract class TruckRemoteDataSource {
  Future<TruckBaseResponse> getTrucks(int page);
}