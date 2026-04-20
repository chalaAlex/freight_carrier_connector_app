import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/my_bids_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/my_bids_model.dart';

class MyBidsRemoteDataSourceImpl implements MyBidsRemoteDataSource {
  final ApiClient apiClient;
  const MyBidsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MyBidModel>> getMyBids() async {
    final response = await apiClient.getMyBids();
    final bids =
        (response as Map<String, dynamic>)['data']['bids'] as List<dynamic>;
    return bids
        .map((b) => MyBidModel.fromJson(b as Map<String, dynamic>))
        .toList();
  }
}
