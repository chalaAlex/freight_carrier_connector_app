import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/my_bids_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/my_bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/my_bids_repository.dart';

class MyBidsRepositoryImpl implements MyBidsRepository {
  final MyBidsRemoteDataSource remoteDataSource;
  const MyBidsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyBidEntity>>> getMyBids() async {
    try {
      final bids = await remoteDataSource.getMyBids();
      return Right(bids);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
