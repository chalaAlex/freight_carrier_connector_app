import 'package:clean_architecture/feature/my_loads/data/model/my_loads_base_response_model.dart';

abstract class MyLoadsRemoteDataSource {
  Future<MyLoadsBaseResponseModel> getMyLoads(String status);
}
