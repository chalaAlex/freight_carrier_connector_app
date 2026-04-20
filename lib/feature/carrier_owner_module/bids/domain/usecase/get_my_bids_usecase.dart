import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/my_bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/my_bids_repository.dart';

class GetMyBidsUseCase {
  final MyBidsRepository repository;
  const GetMyBidsUseCase(this.repository);

  Future<Either<Failure, List<MyBidEntity>>> call() => repository.getMyBids();
}
