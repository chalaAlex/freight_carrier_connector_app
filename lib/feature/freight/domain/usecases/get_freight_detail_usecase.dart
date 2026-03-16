import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_detail_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/freight_repository.dart';
import 'package:dartz/dartz.dart';

class GetFreightDetailUseCase
    implements UseCase<FreightDetailResponseEntity, String> {
  final FreightRepository repository;

  GetFreightDetailUseCase(this.repository);

  @override
  Future<Either<Failure, FreightDetailResponseEntity>> call(String id) async {
    return await repository.getFreightDetail(id);
  }
}
