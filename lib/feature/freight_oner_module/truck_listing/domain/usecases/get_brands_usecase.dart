import 'package:dartz/dartz.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class GetBrandsUseCase
    implements UseCase<BrandBaseResponseEntity, NoParams> {
  final BrandRepository repository;

  GetBrandsUseCase(this.repository);

  @override
  Future<Either<Failure, BrandBaseResponseEntity>> call(NoParams params) async {
    return await repository.getAllBrands();
  }
}
