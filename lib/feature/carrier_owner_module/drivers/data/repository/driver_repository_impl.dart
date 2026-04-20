import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/datasource/driver_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/model/driver_list_response_model.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/model/driver_model.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource dataSource;

  DriverRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<DriverEntity>>> getMyDrivers() async {
    try {
      final json = await dataSource.getMyDrivers();
      final response = DriverListResponseModel.fromJson(json);
      return Right(response.drivers);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, DriverEntity>> getDriver(String id) async {
    try {
      final json = await dataSource.getDriver(id);
      final data = json['data'] as Map<String, dynamic>;
      final model = DriverModel.fromJson(
        data['driver'] as Map<String, dynamic>,
      );
      return Right(model);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, DriverEntity>> createDriver(
    Map<String, dynamic> body,
  ) async {
    try {
      final json = await dataSource.createDriver(body);
      final data = json['data'] as Map<String, dynamic>;
      final model = DriverModel.fromJson(
        data['driver'] as Map<String, dynamic>,
      );
      return Right(model);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, DriverEntity>> updateDriver(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final json = await dataSource.updateDriver(id, body);
      final data = json['data'] as Map<String, dynamic>;
      final model = DriverModel.fromJson(
        data['driver'] as Map<String, dynamic>,
      );
      return Right(model);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteDriver(String id) async {
    try {
      await dataSource.deleteDriver(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> assignDriver(
    String carrierId,
    String driverId,
  ) async {
    try {
      await dataSource.assignDriver(carrierId, driverId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> unassignDriver(
    String carrierId,
    String driverId,
  ) async {
    try {
      await dataSource.unassignDriver(carrierId, driverId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
