import 'package:equatable/equatable.dart';
import '../../domain/entities/regions_entity.dart';

abstract class RegionState extends Equatable {
  const RegionState();

  @override
  List<Object?> get props => [];
}

class RegionInitial extends RegionState {}

class RegionLoading extends RegionState {}

class RegionSuccess extends RegionState {
  final RegionsBaseResponseEntity regions;

  const RegionSuccess(this.regions);

  @override
  List<Object?> get props => [regions];
}

class RegionError extends RegionState {
  final String message;

  const RegionError(this.message);

  @override
  List<Object?> get props => [message];
}
