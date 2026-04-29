import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';

class GetDriverUseCase extends UseCase<DriverEntity, String> {
  final DriverRepository repository;

  GetDriverUseCase(this.repository);

  @override
  Future<Either<Failure, DriverEntity>> call(String params) {
    return repository.getDriver(params);
  }
}
