import 'package:dartz/dartz.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/feature_entity.dart';
import '../repositories/feature_repository.dart';

class GetFeaturesUseCase
    implements UseCase<FeatureBaseResponseEntity, NoParams> {
  final FeatureRepository repository;

  GetFeaturesUseCase(this.repository);

  @override
  Future<Either<Failure, FeatureBaseResponseEntity>> call(
    NoParams params,
  ) async {
    return await repository.getAllFeatures();
  }
}
