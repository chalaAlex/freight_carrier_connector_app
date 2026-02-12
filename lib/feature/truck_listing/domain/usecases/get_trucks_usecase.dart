import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/domain/repositories/truck_repository.dart';
import 'package:dartz/dartz.dart';

/// Parameters for fetching trucks with optional filters
class GetTrucksParams {
  final int page;
  final String? search;
  final String? company;
  final bool? isAvailable;
  final String? carrierType;

  const GetTrucksParams({
    required this.page,
    this.search,
    this.company,
    this.isAvailable,
    this.carrierType,
  });
}

class GetTrucksUseCase extends UseCase<TruckBaseResponseEntity, GetTrucksParams> {
  final TruckRepository repository;

  GetTrucksUseCase(this.repository);

  @override
  Future<Either<Failure, TruckBaseResponseEntity>> call(GetTrucksParams params) async {
    return await repository.fetchTrucks(
      params.page,
      search: params.search,
      company: params.company,
      isAvailable: params.isAvailable,
      carrierType: params.carrierType,
    );
  }
}

