import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/data/datasources/freight_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_detail_model.dart';
import 'package:clean_architecture/feature/my_loads/data/model/my_loads_base_response_model.dart';

class FreightRemoteDataSourceImpl implements FreightRemoteDataSource {
  final ApiClient client;

  FreightRemoteDataSourceImpl({required this.client});

  @override
  Future<MyLoadsBaseResponseModel> createFreight(
    CreateFreightRequest createFreightrequest,
  ) async {
    return await client.createFreight(createFreightrequest);
  }

  @override
  Future<MyLoadsBaseResponseModel> getMyFreight(int page) async {
    return await client.getMyFreight(page: page);
  }

  @override
  Future<FreightDetailBaseResponse> getFreightDetail(String id) async {
    return await client.getFreightDetail(id);
  }
}
