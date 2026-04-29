import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/data/model/freight_detail_model.dart';
import '../../../my_loads/data/model/my_loads_base_response_model.dart';

abstract class FreightRemoteDataSource {
  Future<MyLoadsBaseResponseModel> createFreight(CreateFreightRequest request);
  Future<MyLoadsBaseResponseModel> getMyFreight(int page);
  Future<MyLoadsBaseResponseModel> getFreights(int page, String? status);
  Future<FreightDetailBaseResponse> getFreightDetail(String id);
}
