import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/freight_detail_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/my_loads/domain/entity/my_loads_entity.dart';
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
  final MyLoadsResponseEntity response;

  const FreightCreateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

/// Success state after fetching freights
class FreightFetchSuccess extends FreightState {
  final MyLoadsResponseEntity response;

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

/// Success state after fetching freight detail
class FreightDetailSuccess extends FreightState {
  final FreightDetailResponseEntity response;

  const FreightDetailSuccess(this.response);

  @override
  List<Object?> get props => [response];
}
