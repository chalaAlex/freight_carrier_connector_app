import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier/domain/repository/favourite_repository.dart';
import 'package:dartz/dartz.dart';

class MakeCarrierFavouriteUseCase {
  final FavouriteRepository repository;
  MakeCarrierFavouriteUseCase(this.repository);

  Future<Either<Failure, void>> call(String carrierId) =>
      repository.makeCarrierFavourite(carrierId);
}

class DisableFavouriteUseCase {
  final FavouriteRepository repository;
  DisableFavouriteUseCase(this.repository);

  Future<Either<Failure, void>> call(String carrierId) =>
      repository.disableFavourite(carrierId);
}
