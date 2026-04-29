import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/my_bids_model.dart';

abstract class MyBidsRemoteDataSource {
  Future<List<MyBidModel>> getMyBids();
}
