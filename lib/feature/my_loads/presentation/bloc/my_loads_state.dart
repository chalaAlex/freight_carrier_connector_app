import 'package:clean_architecture/feature/my_loads/domain/entity/my_loads_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MyLoadsState extends Equatable {
  const MyLoadsState();

  @override
  List<Object?> get props => [];
}

class MyLoadsInitial extends MyLoadsState {}

class MyLoadsLoading extends MyLoadsState {}

class MyLoadsSuccess extends MyLoadsState {
  final List<MyLoadsEntity> freights;
  final String status;

  const MyLoadsSuccess(this.freights, this.status);

  @override
  List<Object?> get props => [freights, status];
}

class MyLoadsError extends MyLoadsState {
  final String message;

  const MyLoadsError(this.message);

  @override
  List<Object?> get props => [message];
}
