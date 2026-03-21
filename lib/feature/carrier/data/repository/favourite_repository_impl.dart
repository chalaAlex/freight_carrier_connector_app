import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier/data/datasource/favourite_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier/domain/repository/favourite_repository.dart';
import 'package:dartz/dartz.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  final FavouriteRemoteDataSource remoteDataSource;

  FavouriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> makeCarrierFavourite(String carrierId) async {
    try {
      await remoteDataSource.makeCarrierFavourite(carrierId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> disableFavourite(String carrierId) async {
    try {
      await remoteDataSource.disableFavourite(carrierId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
