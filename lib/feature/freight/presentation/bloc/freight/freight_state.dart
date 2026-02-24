import 'package:clean_architecture/feature/freight/domain/entity/freight_entity.dart';
import 'package:equatable/equatable.dart';

abstract class FreightState extends Equatable {
  const FreightState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FreightInitial extends FreightState {}

/// Loading state (for create or fetch operations)
class FreightLoading extends FreightState {}

/// Success state after creating freight
class FreightCreateSuccess extends FreightState {
  final FreightBaseResponseEntity response;

  const FreightCreateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state after fetching freights
class FreightFetchSuccess extends FreightState {
  final FreightBaseResponseEntity response;

  const FreightFetchSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Error state
class FreightError extends FreightState {
  final String message;

  const FreightError(this.message);

  @override
  List<Object?> get props => [message];
}
