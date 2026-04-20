import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/entity/my_loads_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/repositories/my_loads_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyLoadsUseCase
    implements UseCase<MyLoadsResponseEntity, String> {
  final MyLoadsRepository repository;

  GetMyLoadsUseCase(this.repository);

  @override
  Future<Either<Failure, MyLoadsResponseEntity>> call(String status) {
    return repository.getMyLoads(status);
  }
}





