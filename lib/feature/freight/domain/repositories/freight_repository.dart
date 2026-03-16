import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/request/create_freight_request.dart';
import 'package:clean_architecture/feature/freight/domain/entity/freight_detail_entity.dart';
import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FreightRepository {
  Future<Either<Failure, MyLoadsResponseEntity>> createFreight(
    CreateFreightRequest request,
  );

  Future<Either<Failure, MyLoadsResponseEntity>> getMyFreight(int page);

  Future<Either<Failure, FreightDetailResponseEntity>> getFreightDetail(
    String id,
  );
}
