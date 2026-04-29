import 'package:equatable/equatable.dart';

class BrandBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final int? total;
  final List<BrandEntity>? brands;

  const BrandBaseResponseEntity({
    this.statusCode,
    this.message,
    this.total,
    this.brands,
  });

  @override
  List<Object?> get props => [statusCode, message, total, brands];
}

class BrandEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        isActive,
        createdAt,
        updatedAt,
      ];
}
