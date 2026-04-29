import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/freight_oner_module/shipment_request/domain/entity/shipment_request_entity.dart';

abstract class ShipmentRequestState extends Equatable {
  const ShipmentRequestState();

  @override
  List<Object?> get props => [];
}

class ShipmentRequestInitial extends ShipmentRequestState {}

class ShipmentRequestLoading extends ShipmentRequestState {}

class ShipmentRequestSuccess extends ShipmentRequestState {
  final RequestResponseEntity response;
  const ShipmentRequestSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ShipmentRequestError extends ShipmentRequestState {
  final String message;
  const ShipmentRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

class ShipmentRequestActionSuccess extends ShipmentRequestState {
  final String message;
  const ShipmentRequestActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
