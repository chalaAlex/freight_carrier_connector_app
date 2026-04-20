import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/bid_repository.dart';

class RejectBidUseCase {
  final BidRepository repository;
  const RejectBidUseCase(this.repository);

  Future<Either<Failure, void>> call(String bidId) =>
      repository.rejectBid(bidId);
}
