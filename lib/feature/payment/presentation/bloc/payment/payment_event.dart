import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class ResetPaymentEvent extends PaymentEvent {}

class InitiatePaymentEvent extends PaymentEvent {
  final String bookingType;
  final String sourceId;
  final String gateway;
  const InitiatePaymentEvent({
    required this.bookingType,
    required this.sourceId,
    required this.gateway,
  });
  @override
  List<Object?> get props => [bookingType, sourceId, gateway];
}

class ConfirmPaymentEvent extends PaymentEvent {
  final String outTradeNo;
  const ConfirmPaymentEvent(this.outTradeNo);
  @override
  List<Object?> get props => [outTradeNo];
}

class GetPaymentByFreightEvent extends PaymentEvent {
  final String freightId;
  const GetPaymentByFreightEvent(this.freightId);
  @override
  List<Object?> get props => [freightId];
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
