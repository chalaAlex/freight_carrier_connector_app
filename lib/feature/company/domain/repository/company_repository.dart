import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CompanyRepository {
  Future<Either<Failure, CompanyBaseResponseEntity>> getRecommendedCompanies();
  Future<Either<Failure, CompanyBaseResponseEntity>> getTopRatedCompanies();
  Future<Either<Failure, CompanyDetailResponseEntity>> getCompanyDetail(
    String id,
  );
}
