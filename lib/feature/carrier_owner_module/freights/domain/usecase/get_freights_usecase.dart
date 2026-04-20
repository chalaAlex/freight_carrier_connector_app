import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freights_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/repository/freights_repository.dart';
import 'package:dartz/dartz.dart';

class GetFreightsParams {
  final int? page;
  final int? limit;
  final FreightFilter? filter;

  const GetFreightsParams({this.page, this.limit, this.filter});
}

class GetFreightsUseCase {
  final FreightsRepository repository;

  GetFreightsUseCase(this.repository);

  Future<Either<Failure, FreightsResponseEntity>> call(
    GetFreightsParams params,
  ) {
    return repository.getFreights(
      page: params.page,
      limit: params.limit,
      filter: params.filter,
    );
  }
}
