import 'package:clean_architecture/feature/freight/domain/entity/location_entity.dart';
import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LocationInitial extends LocationState {}

/// Loading state
class LocationLoading extends LocationState {}

/// Success state with regions
class LocationLoaded extends LocationState {
  final List<RegionEntity> regions;

  const LocationLoaded(this.regions);

  @override
  List<Object?> get props => [regions];
}

/// Error state
class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
