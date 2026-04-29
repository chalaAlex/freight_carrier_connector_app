import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/my_bid_entity.dart';

abstract class MyBidsRepository {
  Future<Either<Failure, List<MyBidEntity>>> getMyBids();
}
