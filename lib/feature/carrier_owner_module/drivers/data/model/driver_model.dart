import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';

class DriverModel extends DriverEntity {
  const DriverModel({
    required super.id,
    super.firstName,
    super.lastName,
    super.email,
    super.phone,
    super.licenseNumber,
    super.licenseExpiry,
    super.licenseImageUrl,
    super.assignedCarrierId,
    super.assignedCarrierName,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    final assignedTruck = json['assignedTruck'];
    String? assignedCarrierId;
    String? assignedCarrierName;

    if (assignedTruck is Map<String, dynamic>) {
      assignedCarrierId = assignedTruck['_id'] as String?;
      final brand = assignedTruck['brand'] as String?;
      final model = assignedTruck['model'] as String?;
      if (brand != null && model != null) {
        assignedCarrierName = '$brand $model';
      } else {
        assignedCarrierName = brand ?? model;
      }
    }

    return DriverModel(
      id: json['_id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      licenseExpiry: json['licenseExpiry'] != null
          ? DateTime.tryParse(json['licenseExpiry'] as String)
          : null,
      licenseImageUrl: json['licenseImage'] as String?,
      assignedCarrierId: assignedCarrierId,
      assignedCarrierName: assignedCarrierName,
    );
  }
}
