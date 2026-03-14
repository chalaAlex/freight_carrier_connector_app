import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/brand_entity.dart';

abstract class BrandRepository {
  Future<Either<Failure, BrandBaseResponseEntity>> getAllBrands();
}
