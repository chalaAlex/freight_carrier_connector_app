import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/data/datasources/freight_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_detail_entity.dart';
import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/freight_repository.dart';
import 'package:dartz/dartz.dart';

class FreightRepositoryImpl implements FreightRepository {
  final FreightRemoteDataSource remoteDataSource;

  FreightRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MyLoadsResponseEntity>> createFreight(
    CreateFreightRequest request,
  ) async {
    try {
      final response = await remoteDataSource.createFreight(request);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(Failure(response.statusCode!, response.message!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, MyLoadsResponseEntity>> getMyFreight(int page) async {
    try {
      final response = await remoteDataSource.getMyFreight(page);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(Failure(response.statusCode!, response.message!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, MyLoadsResponseEntity>> getFreights(
    int page,
    String? status,
  ) async {
    try {
      final response = await remoteDataSource.getFreights(page, status);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(Failure(response.statusCode!, response.message!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, FreightDetailResponseEntity>> getFreightDetail(
    String id,
  ) async {
    try {
      final response = await remoteDataSource.getFreightDetail(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toDetailEntity());
      } else {
        return Left(Failure(response.statusCode, response.message));
      }
    } catch (error) {
      print(">>>>>>> $error");
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
