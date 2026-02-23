import 'package:equatable/equatable.dart';

class RegionBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final List<RegionEntity>? data;

  const RegionBaseResponseEntity({this.statusCode, this.message, this.data});

  @override
  List<Object?> get props => [statusCode, message, data];
}

class RegionEntity extends Equatable {
  final String? id;
  final String? region;
  final List<String>? cities;

  const RegionEntity({this.id, this.region, this.cities});

  @override
  List<Object?> get props => [id, region, cities];
}
