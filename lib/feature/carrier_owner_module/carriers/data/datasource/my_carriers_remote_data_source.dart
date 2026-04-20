import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/my_carriers_model.dart';

abstract class MyCarriersRemoteDataSource {
  Future<MyCarriersResponseModel> getMyCarriers();
}
