import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/bid_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/bid_model.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/model/get_bid_response.dart';

class BidRemoteDataSourceImpl implements BidRemoteDataSource {
  final ApiClient client;

  BidRemoteDataSourceImpl({required this.client});

  @override
  Future<CreateBidResponseModel> createBid({
    required String freightId,
    required String carrierId,
    required double bidAmount,
    required String message,
  }) {
    return client.createBid(freightId, carrierId, bidAmount, message);
  }

  @override
  Future<GetBidResponse> getBid(String bidId) => client.getBid(bidId);

  @override
  Future<void> acceptBid(String bidId) => client.acceptBid(bidId);

  @override
  Future<void> rejectBid(String bidId) => client.rejectBid(bidId);
}
