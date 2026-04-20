import 'package:equatable/equatable.dart';

class RegionsBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<RegionEntity>? regions;

  const RegionsBaseResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.regions,
  });

  @override
  List<Object?> get props => [statusCode, message, total, regions];
}

class RegionEntity extends Equatable {
  final String id;
  final String name;
  final String country;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RegionEntity({
    required this.id,
    required this.name,
    required this.country,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    country,
    isActive,
    createdAt,
    updatedAt,
  ];
}
