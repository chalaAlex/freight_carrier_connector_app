import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/my_carriers_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/repository/my_carriers_repository.dart';
import 'package:dartz/dartz.dart';

class MyCarriersRepositoryImpl implements MyCarriersRepository {
  final MyCarriersRemoteDataSource remoteDataSource;

  MyCarriersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MyCarriersResponseEntity>> getMyCarriers() async {
    try {
      final response = await remoteDataSource.getMyCarriers();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.toEntity());
      } else {
        return Left(
          Failure(
            response.statusCode ?? 0,
            response.message ?? 'Unknown error',
          ),
        );
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
