import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DriverRepository {
  Future<Either<Failure, List<DriverEntity>>> getMyDrivers();

  Future<Either<Failure, DriverEntity>> getDriver(String id);

  Future<Either<Failure, DriverEntity>> createDriver(Map<String, dynamic> body);

  Future<Either<Failure, DriverEntity>> updateDriver(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, void>> deleteDriver(String id);

  Future<Either<Failure, void>> assignDriver(String carrierId, String driverId);

  Future<Either<Failure, void>> unassignDriver(
    String carrierId,
    String driverId,
  );
}
