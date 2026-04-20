import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/data/datasource/bid_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/get_bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/repository/bid_repository.dart';
import 'package:dartz/dartz.dart';

class BidRepositoryImpl implements BidRepository {
  final BidRemoteDataSource remoteDataSource;

  BidRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CreateBidResponseEntity>> createBid({
    required String freightId,
    required String carrierId,
    required double bidAmount,
    required String message,
  }) async {
    try {
      final response = await remoteDataSource.createBid(
        freightId: freightId,
        carrierId: carrierId,
        bidAmount: bidAmount,
        message: message,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(
          Failure(
            response.statusCode ?? 0,
            response.message ?? 'Unknown error',
          ),
        );
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, GetBidResponseEntity>> getBid(String bidId) async {
    try {
      final response = await remoteDataSource.getBid(bidId);
      return Right(response.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, void>> acceptBid(String bidId) async {
    try {
      await remoteDataSource.acceptBid(bidId);
      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, void>> rejectBid(String bidId) async {
    try {
      await remoteDataSource.rejectBid(bidId);
      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
