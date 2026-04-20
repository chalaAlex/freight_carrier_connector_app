import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';

abstract class FavouriteRepository {
  Future<Either<Failure, void>> makeCarrierFavourite(String carrierId);
  Future<Either<Failure, void>> disableFavourite(String carrierId);
}
