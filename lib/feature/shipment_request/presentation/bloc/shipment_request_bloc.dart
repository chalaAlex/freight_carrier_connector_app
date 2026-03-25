import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/domain/usecases/create_shipment_request_usecase.dart';
import 'package:clean_architecture/feature/shipment_request/domain/usecases/cancel_request_usecase.dart';
import 'package:clean_architecture/feature/shipment_request/domain/usecases/complete_request_usecase.dart';
import 'shipment_request_event.dart';
import 'shipment_request_state.dart';

class ShipmentRequestBloc
    extends Bloc<ShipmentRequestEvent, ShipmentRequestState> {
  final CreateShipmentRequestUseCase createShipmentRequestUseCase;
  final CancelRequestUseCase cancelRequestUseCase;
  final CompleteRequestUseCase completeRequestUseCase;

  ShipmentRequestBloc({
    required this.createShipmentRequestUseCase,
    required this.cancelRequestUseCase,
    required this.completeRequestUseCase,
  }) : super(ShipmentRequestInitial()) {
    on<SubmitShipmentRequest>(_onSubmit);
    on<CancelShipmentRequest>(_onCancel);
    on<CompleteShipmentRequest>(_onComplete);
  }

  Future<void> _onSubmit(
    SubmitShipmentRequest event,
    Emitter<ShipmentRequestState> emit,
  ) async {
    emit(ShipmentRequestLoading());
    final result = await createShipmentRequestUseCase(
      CreateShipmentRequest(
        carrierId: event.carrierId,
        freightIds: event.freightIds,
        proposedPrice: event.proposedPrice,
      ),
    );
    result.fold(
      (failure) => emit(ShipmentRequestError(failure.message)),
      (response) => emit(ShipmentRequestSuccess(response)),
    );
  }

  Future<void> _onCancel(
    CancelShipmentRequest event,
    Emitter<ShipmentRequestState> emit,
  ) async {
    emit(ShipmentRequestLoading());
    final result = await cancelRequestUseCase(event.id);
    result.fold(
      (failure) => emit(ShipmentRequestError(failure.message)),
      (_) => emit(
        const ShipmentRequestActionSuccess('Request cancelled successfully'),
      ),
    );
  }

  Future<void> _onComplete(
    CompleteShipmentRequest event,
    Emitter<ShipmentRequestState> emit,
  ) async {
    emit(ShipmentRequestLoading());
    final result = await completeRequestUseCase(event.id);
    result.fold(
      (failure) => emit(ShipmentRequestError(failure.message)),
      (_) => emit(
        const ShipmentRequestActionSuccess('Shipment marked as completed'),
      ),
    );
  }
}
