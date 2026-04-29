import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/create_carrier_request.dart';

abstract class CarrierRegistrationRemoteDataSource {
  Future<dynamic> createCarrier(CreateCarrierRequest request);
}
