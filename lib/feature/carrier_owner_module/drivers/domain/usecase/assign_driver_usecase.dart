import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class AssignDriverParams extends Equatable {
  final String carrierId;
  final String driverId;

  const AssignDriverParams({required this.carrierId, required this.driverId});

  @override
  List<Object> get props => [carrierId, driverId];
}

class AssignDriverUseCase extends UseCase<void, AssignDriverParams> {
  final DriverRepository repository;

  AssignDriverUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AssignDriverParams params) {
    return repository.assignDriver(params.carrierId, params.driverId);
  }
}
