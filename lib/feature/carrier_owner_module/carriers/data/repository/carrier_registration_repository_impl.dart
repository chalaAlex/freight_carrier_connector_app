import 'package:clean_architecture/cofig/mapper.dart';
import 'package:clean_architecture/core/error/error_handler.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/carrier_registration_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/create_carrier_request.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/my_carriers_model.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/repository/carrier_registration_repository.dart';
import 'package:dartz/dartz.dart';

class CarrierRegistrationRepositoryImpl
    implements CarrierRegistrationRepository {
  final CarrierRegistrationRemoteDataSource remoteDataSource;

  CarrierRegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MyCarrierEntity>> createCarrier(
    CreateCarrierRequest request,
  ) async {
    try {
      final response = await remoteDataSource.createCarrier(request);
      final statusCode = response['statusCode'] as int?;
      if (statusCode == 200 || statusCode == 201) {
        final carrierJson = response['data']['carrier'] as Map<String, dynamic>;
        final entity = MyCarrierModel.fromJson(carrierJson).toEntity();
        return Right(entity);
      } else {
        return Left(
          Failure(
            statusCode ?? 0,
            response['message'] as String? ?? 'Unknown error',
          ),
        );
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
