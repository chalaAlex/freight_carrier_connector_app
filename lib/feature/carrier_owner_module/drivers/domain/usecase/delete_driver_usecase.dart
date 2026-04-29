import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteDriverUseCase extends UseCase<void, String> {
  final DriverRepository repository;

  DeleteDriverUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteDriver(params);
  }
}
