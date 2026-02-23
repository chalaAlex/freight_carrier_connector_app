import 'package:clean_architecture/feature/freight/data/model/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<LocationBaseResponse> getLocations({
    int? page,
    int? limit,
    String? search,
    String? region,
  });
}
