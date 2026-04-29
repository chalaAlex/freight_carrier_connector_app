import '../models/regions_model.dart';

abstract class RegionRemoteDataSource {
  Future<RegionsBaseResponse> getAllRegions();
}
