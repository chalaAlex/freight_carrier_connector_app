import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/datasource/carrier_registration_remote_data_source.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/create_carrier_request.dart';

class CarrierRegistrationRemoteDataSourceImpl
    implements CarrierRegistrationRemoteDataSource {
  final ApiClient client;

  CarrierRegistrationRemoteDataSourceImpl({required this.client});

  @override
  Future<dynamic> createCarrier(CreateCarrierRequest request) =>
      client.createCarrier(request);
}
