import 'package:equatable/equatable.dart';

class CitiesBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<CityEntity>? cities;

  const CitiesBaseResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.cities,
  });

  @override
  List<Object?> get props => [statusCode, message, total, cities];
}

class CityEntity extends Equatable {
  final String id;
  final String name;
  final String? regionId;
  final String? regionName;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CityEntity({
    required this.id,
    required this.name,
    this.regionId,
    this.regionName,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    regionId,
    regionName,
    isActive,
    createdAt,
    updatedAt,
  ];
}
