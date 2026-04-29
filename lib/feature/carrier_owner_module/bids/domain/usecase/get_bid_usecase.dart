import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/get_bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/bid_repository.dart';

class GetBidUseCase {
  final BidRepository repository;
  const GetBidUseCase(this.repository);

  Future<Either<Failure, GetBidResponseEntity>> call(String bidId) =>
      repository.getBid(bidId);
}
