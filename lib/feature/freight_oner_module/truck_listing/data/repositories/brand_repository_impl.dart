import 'package:dartz/dartz.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/cofig/mapper.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_remote_data_source.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource remoteDataSource;

  BrandRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, BrandBaseResponseEntity>> getAllBrands() async {
    try {
      final response = await remoteDataSource.getAllBrands();
      
      return Right(response.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
