import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/bid_model.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/get_bid_response.dart';

abstract class BidRemoteDataSource {
  Future<CreateBidResponseModel> createBid({
    required String freightId,
    required String carrierId,
    required double bidAmount,
    required String message,
  });

  Future<GetBidResponse> getBid(String bidId);
  Future<void> acceptBid(String bidId);
  Future<void> rejectBid(String bidId);
}
