import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';

class CreateDriverUseCase extends UseCase<DriverEntity, Map<String, dynamic>> {
  final DriverRepository repository;

  CreateDriverUseCase(this.repository);

  @override
  Future<Either<Failure, DriverEntity>> call(Map<String, dynamic> params) {
    return repository.createDriver(params);
  }
}
