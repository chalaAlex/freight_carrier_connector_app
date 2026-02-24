import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/data/datasources/freight_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/data/model/freight_response_model.dart';

class FreightRemoteDataSourceImpl implements FreightRemoteDataSource {
  final ApiClient client;

  FreightRemoteDataSourceImpl({required this.client});

  @override
  Future<FreightBaseResponse> createFreight(
    CreateFreightRequest createFreightrequest,
  ) async {
    return await client.createFreight(createFreightrequest);
  }

  @override
  Future<FreightBaseResponse> getFreights(int page) async {
    throw UnimplementedError('Get freights not yet implemented');
  }
}
