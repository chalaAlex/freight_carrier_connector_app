import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:clean_architecture/feature/landing/domain/repositories/featured_carrier_repository.dart';
import 'package:dartz/dartz.dart';

class GetFeaturedCarriersUseCase
    extends UseCase<FeaturedCarrierResponseEntity, NoParams> {
  final FeaturedCarrierRepository repository;

  GetFeaturedCarriersUseCase(this.repository);

  @override
  Future<Either<Failure, FeaturedCarrierResponseEntity>> call(
    NoParams params,
  ) async {
    return await repository.getFeaturedCarriers();
  }
}
