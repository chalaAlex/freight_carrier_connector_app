import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MyLoadsRepository {
  Future<Either<Failure, MyLoadsResponseEntity>> getMyLoads(
    String status,
  );
}
