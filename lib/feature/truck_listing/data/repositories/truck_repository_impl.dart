import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/data/datasources/mock_truck_api_service.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/domain/repositories/truck_repository.dart';
import 'package:dartz/dartz.dart';

/// Network-related failure
class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(-7, message);
}

/// Unexpected/unknown failure
class UnexpectedFailure extends Failure {
  UnexpectedFailure(String message) : super(-1, message);
}

/// Implementation of TruckRepository that delegates to MockTruckApiService
/// 
/// This repository bridges the domain and data layers, handling data fetching
/// and error mapping from exceptions to failures.
class TruckRepositoryImpl implements TruckRepository {
  final MockTruckApiService apiService;

  TruckRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<Truck>>> fetchTrucks(int page) async {
    try {
      final trucks = await apiService.fetchTrucks(page);
      return Right(trucks);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }
}
