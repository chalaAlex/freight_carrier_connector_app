// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_carrier_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarrierDocumentsRequest _$CarrierDocumentsRequestFromJson(
  Map<String, dynamic> json,
) => CarrierDocumentsRequest(
  vehicleRegistration: json['vehicleRegistration'] as String,
  tradeLicense: json['tradeLicense'] as String,
  ownerDigitalId: json['ownerDigitalId'] as String,
);

Map<String, dynamic> _$CarrierDocumentsRequestToJson(
  CarrierDocumentsRequest instance,
) => <String, dynamic>{
  'vehicleRegistration': instance.vehicleRegistration,
  'tradeLicense': instance.tradeLicense,
  'ownerDigitalId': instance.ownerDigitalId,
};

CreateCarrierOperatingCorrider _$CreateCarrierOperatingCorriderFromJson(
  Map<String, dynamic> json,
) => CreateCarrierOperatingCorrider(
  startLocation: json['startLocation'] as String,
  destinationLocation: json['destinationLocation'] as String,
);

Map<String, dynamic> _$CreateCarrierOperatingCorriderToJson(
  CreateCarrierOperatingCorrider instance,
) => <String, dynamic>{
  'startLocation': instance.startLocation,
  'destinationLocation': instance.destinationLocation,
};

CreateCarrierRequest _$CreateCarrierRequestFromJson(
  Map<String, dynamic> json,
) => CreateCarrierRequest(
  model: json['model'] as String,
  plateNumber: json['plateNumber'] as String,
  brand: json['brand'] as String,
  loadCapacity: (json['loadCapacity'] as num).toDouble(),
  features: (json['features'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  operatingCorrider: CreateCarrierOperatingCorrider.fromJson(
    json['operatingCorrider'] as Map<String, dynamic>,
  ),
  aboutTruck: json['aboutTruck'] as String,
  documents: CarrierDocumentsRequest.fromJson(
    json['documents'] as Map<String, dynamic>,
  ),
  image:
      (json['image'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$CreateCarrierRequestToJson(
  CreateCarrierRequest instance,
) => <String, dynamic>{
  'model': instance.model,
  'plateNumber': instance.plateNumber,
  'brand': instance.brand,
  'loadCapacity': instance.loadCapacity,
  'features': instance.features,
  'operatingCorrider': instance.operatingCorrider,
  'aboutTruck': instance.aboutTruck,
  'documents': instance.documents,
  'image': instance.image,
};
