import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FeaturedCarrierRepository {
  Future<Either<Failure, FeaturedCarrierResponseEntity>> getFeaturedCarriers();
}
