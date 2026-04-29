import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/repository/driver_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateDriverParams extends Equatable {
  final String id;
  final Map<String, dynamic> body;

  const UpdateDriverParams({required this.id, required this.body});

  @override
  List<Object> get props => [id, body];
}

class UpdateDriverUseCase extends UseCase<DriverEntity, UpdateDriverParams> {
  final DriverRepository repository;

  UpdateDriverUseCase(this.repository);

  @override
  Future<Either<Failure, DriverEntity>> call(UpdateDriverParams params) {
    return repository.updateDriver(params.id, params.body);
  }
}
