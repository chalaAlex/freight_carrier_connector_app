import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/data/datasources/shipment_request_remote_data_source.dart';
import 'package:clean_architecture/feature/shipment_request/data/model/sent_requests_response_model.dart';
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

  @override
  Future<Either<Failure, List<SentRequestEntity>>> getSentRequests(
    String status,
  ) async {
    try {
      final result = await remoteDataSource.getSentRequests(status);
      return Right(result.requests.map(_toEntity).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> cancelRequest(String id) async {
    try {
      await remoteDataSource.cancelRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> completeRequest(String id) async {
    try {
      await remoteDataSource.completeRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  SentRequestEntity _toEntity(SentRequestModel m) {
    return SentRequestEntity(
      id: m.id,
      status: m.status,
      isReviewed: m.isReviewed,
      proposedPrice: m.proposedPrice,
      createdAt: m.createdAt,
      carrier: m.carrier == null
          ? null
          : SentCarrierEntity(
              id: m.carrier!.id,
              brand: m.carrier!.brand,
              model: m.carrier!.model,
              plateNumber: m.carrier!.plateNumber,
            ),
      freightSnapshots: m.freightSnapshots
          .map(
            (s) => SentSnapshotEntity(
              cargoType: s.cargoType,
              pickupCity: s.pickupCity,
              deliveryCity: s.deliveryCity,
            ),
          )
          .toList(),
    );
  }
}
