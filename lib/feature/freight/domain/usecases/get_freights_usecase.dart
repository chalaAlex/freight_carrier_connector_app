import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/freight_repository.dart';
import 'package:dartz/dartz.dart';

class GetFreightsUseCase extends UseCase<FreightBaseResponseEntity, int> {
  final FreightRepository repository;

  GetFreightsUseCase(this.repository);

  @override
  Future<Either<Failure, FreightBaseResponseEntity>> call(int page) async {
    return await repository.getFreights(page);
  }
}
