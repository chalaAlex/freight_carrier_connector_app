import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/bid_repository.dart';
import 'package:dartz/dartz.dart';

class CreateBidParams {
  final String freightId;
  final String carrierId;
  final double bidAmount;
  final String message;

  const CreateBidParams({
    required this.freightId,
    required this.carrierId,
    required this.bidAmount,
    required this.message,
  });
}

class CreateBidUseCase {
  final BidRepository repository;

  CreateBidUseCase(this.repository);

  Future<Either<Failure, CreateBidResponseEntity>> call(
    CreateBidParams params,
  ) {
    return repository.createBid(
      freightId: params.freightId,
      carrierId: params.carrierId,
      bidAmount: params.bidAmount,
      message: params.message,
    );
  }
}
