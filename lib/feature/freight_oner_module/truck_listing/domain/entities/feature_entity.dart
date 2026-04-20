import 'package:equatable/equatable.dart';

class FeatureBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<FeatureEntity>? features;

  const FeatureBaseResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.features,
  });

  @override
  List<Object?> get props => [statusCode, message, total, features];
}

class FeatureEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FeatureEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        description,
        isActive,
        createdAt,
        updatedAt,
      ];
}
