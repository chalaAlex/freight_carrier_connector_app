import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/data/datasources/cargo_type_remote_data_source.dart';
import 'package:clean_architecture/feature/freight/domain/entity/cargo_type_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/cargo_type_repository.dart';
import 'package:dartz/dartz.dart';

class CargoTypeRepositoryImpl implements CargoTypeRepository {
  final CargoTypeRemoteDataSource _remoteDataSource;

  CargoTypeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CargoTypeBaseResponseEntity>> getCargoTypes() async {
    try {
      final response = await _remoteDataSource.getCargoTypes();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(Failure(response.statusCode!, response.message!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
