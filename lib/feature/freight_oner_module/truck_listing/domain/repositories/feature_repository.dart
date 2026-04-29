import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/feature_entity.dart';

abstract class FeatureRepository {
  Future<Either<Failure, FeatureBaseResponseEntity>> getAllFeatures();
}
