import 'package:clean_architecture/core/request/create_freight_request.dart';
import '../model/freight_response_model.dart';

abstract class FreightRemoteDataSource {
  Future<FreightBaseResponse> createFreight(CreateFreightRequest request);
  Future<FreightBaseResponse> getFreights(int page);
}
