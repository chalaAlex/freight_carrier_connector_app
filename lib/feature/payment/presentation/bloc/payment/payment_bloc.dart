import 'package:clean_architecture/feature/payment/domain/usecase/confirm_payment_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/dispute_payment_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/get_payment_by_freight_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/get_payment_status_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/initiate_payment_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/release_payment_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final GetPaymentByFreightUseCase getPaymentByFreightUseCase;
  final GetPaymentStatusUseCase getPaymentStatusUseCase;
  final ReleasePaymentUseCase releasePaymentUseCase;
  final DisputePaymentUseCase disputePaymentUseCase;

  PaymentBloc({
    required this.initiatePaymentUseCase,
    required this.confirmPaymentUseCase,
    required this.getPaymentByFreightUseCase,
    required this.getPaymentStatusUseCase,
    required this.releasePaymentUseCase,
    required this.disputePaymentUseCase,
  }) : super(PaymentInitial()) {
    on<ResetPaymentEvent>((_, emit) => emit(PaymentInitial()));
    on<InitiatePaymentEvent>(_onInitiate);
    on<ConfirmPaymentEvent>(_onConfirm);
    on<GetPaymentByFreightEvent>(_onGetByFreight);
    on<GetPaymentStatusEvent>(_onGetStatus);
    on<ReleasePaymentEvent>(_onRelease);
    on<DisputePaymentEvent>(_onDispute);
  }

  Future<void> _onInitiate(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await initiatePaymentUseCase(
      InitiatePaymentParams(
        bookingType: event.bookingType,
        sourceId: event.sourceId,
        gateway: event.gateway,
      ),
    );
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (data) => emit(PaymentInitiated(data)),
    );
  }

  Future<void> _onConfirm(
    ConfirmPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await confirmPaymentUseCase(event.outTradeNo);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentConfirmed(payment)),
    );
  }

  Future<void> _onGetByFreight(
    GetPaymentByFreightEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentByFreightUseCase(event.freightId);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentByFreightLoaded(payment)),
    );
  }

  Future<void> _onGetStatus(
    GetPaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await getPaymentStatusUseCase(event.paymentId);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentStatusLoaded(payment)),
    );
  }

  Future<void> _onRelease(
    ReleasePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await releasePaymentUseCase(event.paymentId);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentReleased(payment)),
    );
  }

  Future<void> _onDispute(
    DisputePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await disputePaymentUseCase(event.paymentId);
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentDisputed(payment)),
    );
  }
}
