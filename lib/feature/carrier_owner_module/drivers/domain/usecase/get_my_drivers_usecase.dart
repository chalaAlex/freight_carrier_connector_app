import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyDriversUseCase extends UseCase<List<DriverEntity>, NoParams> {
  final DriverRepository repository;

  GetMyDriversUseCase(this.repository);

  @override
  Future<Either<Failure, List<DriverEntity>>> call(NoParams params) {
    return repository.getMyDrivers();
  }
}
