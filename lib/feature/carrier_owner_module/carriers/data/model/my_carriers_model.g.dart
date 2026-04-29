// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_carriers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCarriersResponseModel _$MyCarriersResponseModelFromJson(
  Map<String, dynamic> json,
) => MyCarriersResponseModel(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  results: (json['results'] as num?)?.toInt(),
  data: json['data'] == null
      ? null
      : MyCarriersData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MyCarriersResponseModelToJson(
  MyCarriersResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'results': instance.results,
  'data': instance.data,
};

MyCarriersData _$MyCarriersDataFromJson(Map<String, dynamic> json) =>
    MyCarriersData(
      carriers: (json['carriers'] as List<dynamic>?)
          ?.map((e) => MyCarrierModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyCarriersDataToJson(MyCarriersData instance) =>
    <String, dynamic>{'carriers': instance.carriers};

MyCarrierModel _$MyCarrierModelFromJson(Map<String, dynamic> json) =>
    MyCarrierModel(
      id: json['_id'] as String?,
      model: json['model'] as String?,
      plateNumber: json['plateNumber'] as String?,
      brand: json['brand'] as String?,
      loadCapacity: (json['loadCapacity'] as num?)?.toDouble(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      operatingCorrider: json['operatingCorrider'] == null
          ? null
          : MyCarrierOperatingCorrider.fromJson(
              json['operatingCorrider'] as Map<String, dynamic>,
            ),
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      aboutTruck: json['aboutTruck'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      isVerified: json['isVerified'] as bool?,
      documents: json['documents'] == null
          ? null
          : CarrierDocumentsModel.fromJson(
              json['documents'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MyCarrierModelToJson(MyCarrierModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'model': instance.model,
      'plateNumber': instance.plateNumber,
      'brand': instance.brand,
      'loadCapacity': instance.loadCapacity,
      'features': instance.features,
      'operatingCorrider': instance.operatingCorrider,
      'image': instance.image,
      'aboutTruck': instance.aboutTruck,
      'isAvailable': instance.isAvailable,
      'isVerified': instance.isVerified,
      'documents': instance.documents,
    };

CarrierDocumentsModel _$CarrierDocumentsModelFromJson(
  Map<String, dynamic> json,
) => CarrierDocumentsModel(
  vehicleRegistration: json['vehicleRegistration'] as String?,
  tradeLicense: json['tradeLicense'] as String?,
  ownerDigitalId: json['ownerDigitalId'] as String?,
);

Map<String, dynamic> _$CarrierDocumentsModelToJson(
  CarrierDocumentsModel instance,
) => <String, dynamic>{
  'vehicleRegistration': instance.vehicleRegistration,
  'tradeLicense': instance.tradeLicense,
  'ownerDigitalId': instance.ownerDigitalId,
};

MyCarrierOperatingCorrider _$MyCarrierOperatingCorriderFromJson(
  Map<String, dynamic> json,
) => MyCarrierOperatingCorrider(
  startLocation: json['startLocation'] as String?,
  destinationLocation: json['destinationLocation'] as String?,
);

Map<String, dynamic> _$MyCarrierOperatingCorriderToJson(
  MyCarrierOperatingCorrider instance,
) => <String, dynamic>{
  'startLocation': instance.startLocation,
  'destinationLocation': instance.destinationLocation,
};
