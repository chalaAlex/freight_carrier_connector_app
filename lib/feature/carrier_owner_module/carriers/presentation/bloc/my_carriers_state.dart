import 'package:clean_architecture/feature/carrier_owner_module/carriers/domain/entity/my_carrier_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MyCarriersState extends Equatable {
  const MyCarriersState();
  @override
  List<Object?> get props => [];
}

class MyCarriersInitial extends MyCarriersState {}

class MyCarriersLoading extends MyCarriersState {}

class MyCarriersSuccess extends MyCarriersState {
  final List<MyCarrierEntity> carriers;
  const MyCarriersSuccess(this.carriers);
  @override
  List<Object?> get props => [carriers];
}

class MyCarriersError extends MyCarriersState {
  final String message;
  const MyCarriersError(this.message);
  @override
  List<Object?> get props => [message];
}
