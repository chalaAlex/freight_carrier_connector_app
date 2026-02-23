import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/freight_repository.dart';
import 'package:dartz/dartz.dart';

class CreateFreightUseCase
    extends UseCase<FreightBaseResponseEntity, CreateFreightRequest> {
  final FreightRepository repository;

  CreateFreightUseCase(this.repository);

  @override
  Future<Either<Failure, FreightBaseResponseEntity>> call(
    CreateFreightRequest params,
  ) async {
    return await repository.createFreight(params);
  }
}
