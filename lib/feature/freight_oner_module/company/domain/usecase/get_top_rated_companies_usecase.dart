import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/entity/company_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/repository/company_repository.dart';
import 'package:dartz/dartz.dart';

class GetTopRatedCompaniesUseCase
    implements UseCase<CompanyBaseResponseEntity, NoParams> {
  final CompanyRepository repository;

  GetTopRatedCompaniesUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyBaseResponseEntity>> call(
    NoParams params,
  ) async {
    return await repository.getTopRatedCompanies();
  }
}
