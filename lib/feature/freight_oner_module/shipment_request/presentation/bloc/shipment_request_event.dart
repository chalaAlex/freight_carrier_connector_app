import 'package:equatable/equatable.dart';

abstract class ShipmentRequestEvent extends Equatable {
  const ShipmentRequestEvent();

  @override
  List<Object?> get props => [];
}

class SubmitShipmentRequest extends ShipmentRequestEvent {
  final String carrierId;
  final List<String> freightIds;
  final int? proposedPrice;

  const SubmitShipmentRequest({
    required this.carrierId,
    required this.freightIds,
    this.proposedPrice,
  });

  @override
  List<Object?> get props => [carrierId, freightIds, proposedPrice];
}

class CancelShipmentRequest extends ShipmentRequestEvent {
  final String id;
  const CancelShipmentRequest(this.id);
  @override
  List<Object?> get props => [id];
}

class CompleteShipmentRequest extends ShipmentRequestEvent {
  final String id;
  const CompleteShipmentRequest(this.id);
  @override
  List<Object?> get props => [id];
}
