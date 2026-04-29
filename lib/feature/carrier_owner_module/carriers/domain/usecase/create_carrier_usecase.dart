import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/data/model/create_carrier_request.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/repository/carrier_registration_repository.dart';
import 'package:dartz/dartz.dart';

class CreateCarrierParams {
  final String model;
  final String plateNumber;
  final String brand;
  final double loadCapacity;
  final List<String> features;
  final String startLocation;
  final String destinationLocation;
  final String aboutTruck;
  final String vehicleRegistrationUrl;
  final String tradeLicenseUrl;
  final String ownerDigitalIdUrl;
  final List<String> carrierImageUrls;

  const CreateCarrierParams({
    required this.model,
    required this.plateNumber,
    required this.brand,
    required this.loadCapacity,
    required this.features,
    required this.startLocation,
    required this.destinationLocation,
    required this.aboutTruck,
    required this.vehicleRegistrationUrl,
    required this.tradeLicenseUrl,
    required this.ownerDigitalIdUrl,
    this.carrierImageUrls = const [],
  });
}

class CreateCarrierUseCase {
  final CarrierRegistrationRepository repository;

  CreateCarrierUseCase(this.repository);

  Future<Either<Failure, MyCarrierEntity>> call(CreateCarrierParams params) {
    final request = CreateCarrierRequest(
      model: params.model,
      plateNumber: params.plateNumber,
      brand: params.brand,
      loadCapacity: params.loadCapacity,
      features: params.features,
      operatingCorrider: CreateCarrierOperatingCorrider(
        startLocation: params.startLocation,
        destinationLocation: params.destinationLocation,
      ),
      aboutTruck: params.aboutTruck,
      documents: CarrierDocumentsRequest(
        vehicleRegistration: params.vehicleRegistrationUrl,
        tradeLicense: params.tradeLicenseUrl,
        ownerDigitalId: params.ownerDigitalIdUrl,
      ),
      image: params.carrierImageUrls,
    );

    return repository.createCarrier(request);
  }
}
