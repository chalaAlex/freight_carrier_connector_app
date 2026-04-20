import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/repository/my_carriers_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyCarriersUseCase {
  final MyCarriersRepository repository;

  GetMyCarriersUseCase(this.repository);

  Future<Either<Failure, MyCarriersResponseEntity>> call() {
    return repository.getMyCarriers();
  }
}
