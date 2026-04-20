import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final String bookingType;
  final String sourceId;
  const InitiatePaymentEvent({required this.bookingType, required this.sourceId});
  @override
  List<Object?> get props => [bookingType, sourceId];
}

class GetPaymentStatusEvent extends PaymentEvent {
  final String paymentId;
  const GetPaymentStatusEvent(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}

class ReleasePaymentEvent extends PaymentEvent {
  final String paymentId;
  const ReleasePaymentEvent(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}

class DisputePaymentEvent extends PaymentEvent {
  final String paymentId;
  const DisputePaymentEvent(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}
