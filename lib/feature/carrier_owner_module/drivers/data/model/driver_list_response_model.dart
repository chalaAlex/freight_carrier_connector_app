import 'package:clean_architecture/feature/carrier_owner_module/drivers/data/model/driver_model.dart';

class DriverListResponseModel {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<DriverModel> drivers;

  DriverListResponseModel({
    this.statusCode,
    this.message,
    this.total,
    this.drivers = const [],
  });

  factory DriverListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawDrivers = data['drivers'] as List<dynamic>? ?? [];
    return DriverListResponseModel(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      total: json['total'] as int?,
      drivers: rawDrivers
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
