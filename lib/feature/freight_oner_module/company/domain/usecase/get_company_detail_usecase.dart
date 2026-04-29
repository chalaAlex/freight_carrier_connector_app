import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/entity/company_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/company/domain/repository/company_repository.dart';
import 'package:dartz/dartz.dart';

class GetCompanyDetailUseCase {
  final CompanyRepository repository;

  GetCompanyDetailUseCase(this.repository);

  Future<Either<Failure, CompanyDetailResponseEntity>> call(String id) {
    return repository.getCompanyDetail(id);
  }
}
