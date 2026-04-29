import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/entity/my_loads_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/repositories/freight_repository.dart';
import 'package:dartz/dartz.dart';

class CreateFreightUseCase
    extends UseCase<MyLoadsResponseEntity, CreateFreightRequest> {
  final FreightRepository repository;

  CreateFreightUseCase(this.repository);

  @override
  Future<Either<Failure, MyLoadsResponseEntity>> call(
    CreateFreightRequest params,
  ) async {
    return await repository.createFreight(params);
  }
}
