import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? licenseNumber;
  final DateTime? licenseExpiry;
  final String? licenseImageUrl;
  final String? assignedCarrierId;
  final String? assignedCarrierName;

  const DriverEntity({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.licenseNumber,
    this.licenseExpiry,
    this.licenseImageUrl,
    this.assignedCarrierId,
    this.assignedCarrierName,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    licenseNumber,
    licenseExpiry,
    licenseImageUrl,
    assignedCarrierId,
    assignedCarrierName,
  ];
}
