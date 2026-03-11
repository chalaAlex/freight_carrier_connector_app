import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/company/data/datasources/company_remote_data_source.dart';
import 'package:clean_architecture/feature/company/domain/entity/company_entity.dart';
import 'package:clean_architecture/feature/company/domain/repository/company_repository.dart';
import 'package:dartz/dartz.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CompanyBaseResponseEntity>>
  getRecommendedCompanies() async {
    try {
      final response = await remoteDataSource.getRecommendedCompanies();
      return Right(response.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, CompanyBaseResponseEntity>>
  getTopRatedCompanies() async {
    try {
      final response = await remoteDataSource.getTopRatedCompanies();
      return Right(response.toEntity());
    } catch (error) {
      print("??????? $error");
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
