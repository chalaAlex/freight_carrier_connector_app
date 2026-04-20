abstract class FavouriteRemoteDataSource {
  Future<void> makeCarrierFavourite(String carrierId);
  Future<void> disableFavourite(String carrierId);
}
