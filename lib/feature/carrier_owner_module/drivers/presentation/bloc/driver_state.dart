import 'package:clean_architecture/feature/carrier_owner_module/drivers/domain/entity/driver_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DriverState extends Equatable {
  const DriverState();
  @override
  List<Object?> get props => [];
}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverListLoaded extends DriverState {
  final List<DriverEntity> drivers;
  const DriverListLoaded(this.drivers);
  @override
  List<Object?> get props => [drivers];
}

class DriverLoaded extends DriverState {
  final DriverEntity driver;
  const DriverLoaded(this.driver);
  @override
  List<Object?> get props => [driver];
}

class DriverSuccess extends DriverState {
  final String message;
  const DriverSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DriverError extends DriverState {
  final String message;
  const DriverError(this.message);
  @override
  List<Object?> get props => [message];
}
