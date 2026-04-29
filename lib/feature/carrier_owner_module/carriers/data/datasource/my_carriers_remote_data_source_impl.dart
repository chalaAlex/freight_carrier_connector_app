import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/my_carriers_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/my_carriers_model.dart';

class MyCarriersRemoteDataSourceImpl implements MyCarriersRemoteDataSource {
  final ApiClient client;

  MyCarriersRemoteDataSourceImpl({required this.client});

  @override
  Future<MyCarriersResponseModel> getMyCarriers() => client.getMyCarriers();
}
