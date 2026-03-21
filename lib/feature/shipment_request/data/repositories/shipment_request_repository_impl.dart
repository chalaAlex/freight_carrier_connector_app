import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/data/datasources/shipment_request_remote_data_source.dart';
import 'package:clean_architecture/feature/shipment_request/domain/entity/shipment_request_entity.dart';
import 'package:clean_architecture/feature/shipment_request/domain/repositories/shipment_request_repository.dart';
import 'package:clean_architecture/cofig/mapper.dart';
import 'package:dartz/dartz.dart';

class ShipmentRequestRepositoryImpl implements ShipmentRequestRepository {
  final ShipmentRequestRemoteDataSource remoteDataSource;

  ShipmentRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RequestResponseEntity>> createShipmentRequest(
    CreateShipmentRequest request,
  ) async {
    try {
      final result = await remoteDataSource.createShipmentRequest(request);
      return Right(ShipmentRequestResponseMapper(result).toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
