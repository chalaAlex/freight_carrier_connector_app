import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/request/shipment_request.dart';
import 'package:clean_architecture/feature/shipment_request/domain/usecases/create_shipment_request_usecase.dart';
import 'shipment_request_event.dart';
import 'shipment_request_state.dart';

class ShipmentRequestBloc
    extends Bloc<ShipmentRequestEvent, ShipmentRequestState> {
  final CreateShipmentRequestUseCase createShipmentRequestUseCase;

  ShipmentRequestBloc({required this.createShipmentRequestUseCase})
    : super(ShipmentRequestInitial()) {
    on<SubmitShipmentRequest>(_onSubmit);
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
}
