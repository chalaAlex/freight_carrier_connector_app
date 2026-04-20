import 'dart:io';

import 'package:clean_architecture/core/storage/supabase_storage_service.dart';
import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/usecase/create_carrier_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'carrier_registration_state.dart';

class CarrierRegistrationCubit extends Cubit<CarrierRegistrationState> {
  final CreateCarrierUseCase createCarrierUseCase;
  final SupabaseStorageService storageService;

  final Map<DocumentType, String> _uploadedUrls = {};
  final List<String> _carrierImageUrls = [];

  CarrierRegistrationCubit({
    required this.createCarrierUseCase,
    required this.storageService,
  }) : super(CarrierRegistrationInitial());

  bool get canSubmit =>
      DocumentType.values.every((type) => _uploadedUrls.containsKey(type));

  Future<void> uploadDocument(DocumentType type, File file) async {
    emit(DocumentUploadInProgress(documentType: type));
    try {
      final url = await storageService.upload(
        path:
            'carrier-documents/${type.name}_${DateTime.now().millisecondsSinceEpoch}',
        file: file,
      );
      _uploadedUrls[type] = url;
      emit(DocumentUploadSuccess(documentType: type, url: url));
    } catch (e) {
      emit(DocumentUploadFailure(documentType: type, message: e.toString()));
    }
  }

  Future<String?> uploadCarrierImage(File file) async {
    try {
      final url = await storageService.upload(
        path: 'carrier-images/img_${DateTime.now().millisecondsSinceEpoch}',
        file: file,
      );
      _carrierImageUrls.add(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void removeCarrierImageUrl(String url) {
    _carrierImageUrls.remove(url);
  }

  Future<void> submitRegistration(CarrierRegistrationFormData formData) async {
    if (!canSubmit) {
      emit(
        const CarrierRegistrationFailure(
          message: 'Please upload all required documents',
        ),
      );
      return;
    }

    emit(CarrierRegistrationLoading());

    final params = CreateCarrierParams(
      model: formData.model,
      plateNumber: formData.plateNumber,
      brand: formData.brand,
      loadCapacity: formData.loadCapacity,
      features: formData.features,
      startLocation: formData.startLocation,
      destinationLocation: formData.destinationLocation,
      aboutTruck: formData.aboutTruck,
      vehicleRegistrationUrl: _uploadedUrls[DocumentType.vehicleRegistration]!,
      tradeLicenseUrl: _uploadedUrls[DocumentType.tradeLicense]!,
      ownerDigitalIdUrl: _uploadedUrls[DocumentType.ownerDigitalId]!,
      carrierImageUrls: List.from(_carrierImageUrls),
    );

    final result = await createCarrierUseCase(params);
    result.fold(
      (failure) => emit(CarrierRegistrationFailure(message: failure.message)),
      (carrier) => emit(CarrierRegistrationSuccess(carrier: carrier)),
    );
  }
}
