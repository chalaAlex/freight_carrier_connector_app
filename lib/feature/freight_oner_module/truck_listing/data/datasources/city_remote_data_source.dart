import '../models/cities_model.dart';

abstract class CityRemoteDataSource {
  Future<CitiesBaseResponse> getAllCities();
}
