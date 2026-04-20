import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/cargo_type_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CargoTypeState extends Equatable {
  const CargoTypeState();

  @override
  List<Object?> get props => [];
}

class CargoTypeInitial extends CargoTypeState {
  const CargoTypeInitial();
}

class CargoTypeLoading extends CargoTypeState {
  const CargoTypeLoading();
}

class CargoTypeLoaded extends CargoTypeState {
  final List<CargoTypeEntity> cargoTypes;

  const CargoTypeLoaded(this.cargoTypes);

  @override
  List<Object?> get props => [cargoTypes];
}

class CargoTypeError extends CargoTypeState {
  final String message;

  const CargoTypeError(this.message);

  @override
  List<Object?> get props => [message];
}
