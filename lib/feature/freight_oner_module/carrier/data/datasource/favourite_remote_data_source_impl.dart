import 'package:clean_architecture/core/network/api_client.dart';
import 'favourite_remote_data_source.dart';

class FavouriteRemoteDataSourceImpl implements FavouriteRemoteDataSource {
  final ApiClient apiClient;

  FavouriteRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> makeCarrierFavourite(String carrierId) async {
    await apiClient.makeCarrierFavourite(carrierId);
  }

  @override
  Future<void> disableFavourite(String carrierId) async {
    await apiClient.disableFavourite(carrierId);
  }
}
