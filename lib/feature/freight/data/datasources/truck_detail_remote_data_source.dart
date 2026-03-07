import 'package:clean_architecture/feature/freight/data/model/truck_detail_model.dart';

abstract class TruckDetailRemoteDataSource {
  Future<TruckDetailBaseResponse> getTruckDetail(String truckId);
}
