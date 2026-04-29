import 'package:clean_architecture/feature/freight_oner_module/my_loads/data/model/my_loads_base_response_model.dart';

abstract class MyLoadsRemoteDataSource {
  Future<MyLoadsBaseResponseModel> getMyLoads(String status);
}
