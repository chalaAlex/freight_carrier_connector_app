import 'package:clean_architecture/feature/freight_oner_module/freight/data/model/cargo_type_model.dart';

abstract class CargoTypeRemoteDataSource {
  Future<CargoTypeBaseResponse> getCargoTypes();
}
