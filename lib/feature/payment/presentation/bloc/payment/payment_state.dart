import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentInitiated extends PaymentState {
  final InitiatePaymentEntity data;
  const PaymentInitiated(this.data);
  @override
  List<Object?> get props => [data];
}

class PaymentStatusLoaded extends PaymentState {
  final PaymentEntity payment;
  const PaymentStatusLoaded(this.payment);
  @override
  List<Object?> get props => [payment];
}

class PaymentReleased extends PaymentState {
  final PaymentEntity payment;
  const PaymentReleased(this.payment);
  @override
  List<Object?> get props => [payment];
}

class PaymentDisputed extends PaymentState {
  final PaymentEntity payment;
  const PaymentDisputed(this.payment);
  @override
  List<Object?> get props => [payment];
}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);
  @override
  List<Object?> get props => [message];
}
