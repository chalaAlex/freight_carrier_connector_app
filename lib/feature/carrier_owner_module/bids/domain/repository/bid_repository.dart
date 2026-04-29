import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/get_bid_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BidRepository {
  Future<Either<Failure, CreateBidResponseEntity>> createBid({
    required String freightId,
    required String carrierId,
    required double bidAmount,
    required String message,
  });

  Future<Either<Failure, GetBidResponseEntity>> getBid(String bidId);
  Future<Either<Failure, void>> acceptBid(String bidId);
  Future<Either<Failure, void>> rejectBid(String bidId);
}
