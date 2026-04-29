import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UnassignDriverParams extends Equatable {
  final String carrierId;
  final String driverId;

  const UnassignDriverParams({required this.carrierId, required this.driverId});

  @override
  List<Object> get props => [carrierId, driverId];
}

class UnassignDriverUseCase extends UseCase<void, UnassignDriverParams> {
  final DriverRepository repository;

  UnassignDriverUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UnassignDriverParams params) {
    return repository.unassignDriver(params.carrierId, params.driverId);
  }
}
