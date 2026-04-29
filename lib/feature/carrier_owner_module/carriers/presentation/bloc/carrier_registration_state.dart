import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:equatable/equatable.dart';

enum DocumentType { vehicleRegistration, tradeLicense, ownerDigitalId }

class CarrierRegistrationFormData {
  final String model;
  final String plateNumber;
  final String brand;
  final double loadCapacity;
  final List<String> features;
  final String startLocation;
  final String destinationLocation;
  final String aboutTruck;
  final List<String> carrierImageUrls;

  const CarrierRegistrationFormData({
    required this.model,
    required this.plateNumber,
    required this.brand,
    required this.loadCapacity,
    required this.features,
    required this.startLocation,
    required this.destinationLocation,
    required this.aboutTruck,
    this.carrierImageUrls = const [],
  });
}

abstract class CarrierRegistrationState extends Equatable {
  const CarrierRegistrationState();

  @override
  List<Object?> get props => [];
}

class CarrierRegistrationInitial extends CarrierRegistrationState {}

class DocumentUploadInProgress extends CarrierRegistrationState {
  final DocumentType documentType;

  const DocumentUploadInProgress({required this.documentType});

  @override
  List<Object?> get props => [documentType];
}

class DocumentUploadSuccess extends CarrierRegistrationState {
  final DocumentType documentType;
  final String url;

  const DocumentUploadSuccess({required this.documentType, required this.url});

  @override
  List<Object?> get props => [documentType, url];
}

class DocumentUploadFailure extends CarrierRegistrationState {
  final DocumentType documentType;
  final String message;

  const DocumentUploadFailure({
    required this.documentType,
    required this.message,
  });

  @override
  List<Object?> get props => [documentType, message];
}

class CarrierRegistrationLoading extends CarrierRegistrationState {}

class CarrierRegistrationSuccess extends CarrierRegistrationState {
  final MyCarrierEntity carrier;

  const CarrierRegistrationSuccess({required this.carrier});

  @override
  List<Object?> get props => [carrier];
}

class CarrierRegistrationFailure extends CarrierRegistrationState {
  final String message;

  const CarrierRegistrationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
