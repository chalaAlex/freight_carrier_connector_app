import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/freight_repository.dart';
import 'package:dartz/dartz.dart';

class GetFreightsUseCase extends UseCase<MyLoadsResponseEntity, int> {
  final FreightRepository repository;

  GetFreightsUseCase(this.repository);

  @override
  Future<Either<Failure, MyLoadsResponseEntity>> call(int page) async {
    return await repository.getMyFreight(page);
  }
}
