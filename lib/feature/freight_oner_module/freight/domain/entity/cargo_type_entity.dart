import 'package:equatable/equatable.dart';

class CargoTypeBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<CargoTypeEntity>? data;

  const CargoTypeBaseResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.data,
  });

  @override
  List<Object?> get props => [statusCode, message, total, data];
}

class CargoTypeEntity extends Equatable {
  final String? id;
  final String? cargoType;

  const CargoTypeEntity({this.id, this.cargoType});

  @override
  List<Object?> get props => [id, cargoType];
}
