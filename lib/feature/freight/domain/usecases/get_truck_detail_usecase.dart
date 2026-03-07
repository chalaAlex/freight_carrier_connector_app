import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/entity/truck_detail_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/truck_detail_repository.dart';
import 'package:dartz/dartz.dart';

class GetTruckDetailUseCase
    implements UseCase<TruckDetailBaseEntity, String> {
  final TruckDetailRepository repository;

  GetTruckDetailUseCase(this.repository);

  @override
  Future<Either<Failure, TruckDetailBaseEntity>> call(String truckId) async {
    return await repository.getTruckDetail(truckId);
  }
}
