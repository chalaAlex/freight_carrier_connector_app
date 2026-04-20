import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/entity/my_loads_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/data/datasources/my_loads_remote_data_source.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/repositories/my_loads_repository.dart';
import 'package:dartz/dartz.dart';

class MyLoadsRepositoryImpl implements MyLoadsRepository {
  final MyLoadsRemoteDataSource remoteDataSource;

  MyLoadsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MyLoadsResponseEntity>> getMyLoads(
    String status,
  ) async {
    try {
      final result = await remoteDataSource.getMyLoads(status);
      return Right(result.toEntity());
    } catch (e) {
      print("$e");
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
