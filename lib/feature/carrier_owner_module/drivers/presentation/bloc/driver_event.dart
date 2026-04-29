import 'package:equatable/equatable.dart';

abstract class DriverEvent extends Equatable {
  const DriverEvent();
  @override
  List<Object?> get props => [];
}

class LoadMyDrivers extends DriverEvent {
  const LoadMyDrivers();
}

class LoadDriver extends DriverEvent {
  final String id;
  const LoadDriver(this.id);
  @override
  List<Object?> get props => [id];
}

class CreateDriver extends DriverEvent {
  final Map<String, dynamic> body;
  const CreateDriver(this.body);
  @override
  List<Object?> get props => [body];
}

class UpdateDriver extends DriverEvent {
  final String id;
  final Map<String, dynamic> body;
  const UpdateDriver({required this.id, required this.body});
  @override
  List<Object?> get props => [id, body];
}

class DeleteDriver extends DriverEvent {
  final String id;
  const DeleteDriver(this.id);
  @override
  List<Object?> get props => [id];
}

class AssignDriver extends DriverEvent {
  final String carrierId;
  final String driverId;
  const AssignDriver({required this.carrierId, required this.driverId});
  @override
  List<Object?> get props => [carrierId, driverId];
}

class UnassignDriver extends DriverEvent {
  final String carrierId;
  final String driverId;
  const UnassignDriver({required this.carrierId, required this.driverId});
  @override
  List<Object?> get props => [carrierId, driverId];
}
