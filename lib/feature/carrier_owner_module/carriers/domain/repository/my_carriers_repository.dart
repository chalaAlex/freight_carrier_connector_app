import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MyCarriersRepository {
  Future<Either<Failure, MyCarriersResponseEntity>> getMyCarriers();
}
