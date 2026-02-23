import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:clean_architecture/feature/freight/domain/repositories/location_repository.dart';
import 'package:dartz/dartz.dart';

class GetLocationsUseCase
    implements UseCase<RegionBaseResponseEntity, LocationParams> {
  final LocationRepository repository;

  GetLocationsUseCase(this.repository);

  @override
  Future<Either<Failure, RegionBaseResponseEntity>> call(
    LocationParams params,
  ) async {
    return await repository.getLocations(
      page: params.page,
      limit: params.limit,
      search: params.search,
      region: params.region,
    );
  }
}

class LocationParams {
  final int? page;
  final int? limit;
  final String? search;
  final String? region;

  LocationParams({this.page, this.limit, this.search, this.region});
}
