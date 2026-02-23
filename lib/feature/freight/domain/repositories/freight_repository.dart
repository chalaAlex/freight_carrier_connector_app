import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FreightRepository {
  Future<Either<Failure, FreightBaseResponseEntity>> createFreight(
    CreateFreightRequest request,
  );

  Future<Either<Failure, FreightBaseResponseEntity>> getFreights(int page);
}
