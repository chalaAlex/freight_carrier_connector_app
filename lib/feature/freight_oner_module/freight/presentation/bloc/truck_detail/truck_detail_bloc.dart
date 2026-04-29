import 'package:clean_architecture/feature/freight_oner_module/freight/domain/usecases/get_truck_detail_usecase.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/truck_detail/truck_detail_event.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/presentation/bloc/truck_detail/truck_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TruckDetailBloc extends Bloc<TruckDetailEvent, TruckDetailState> {
  final GetTruckDetailUseCase getTruckDetailUseCase;

  TruckDetailBloc({required this.getTruckDetailUseCase})
    : super(const TruckDetailInitial()) {
    on<FetchTruckDetailEvent>(_onFetchTruckDetail);
    on<ResetTruckDetailEvent>(_onResetTruckDetail);
  }

  Future<void> _onFetchTruckDetail(
    FetchTruckDetailEvent event,
    Emitter<TruckDetailState> emit,
  ) async {
    emit(const TruckDetailLoading());

    final result = await getTruckDetailUseCase(event.truckId);

    result.fold(
      (failure) => emit(TruckDetailError(failure.message)),
      (truckDetail) => emit(TruckDetailLoaded(truckDetail)),
    );
  }

  void _onResetTruckDetail(
    ResetTruckDetailEvent event,
    Emitter<TruckDetailState> emit,
  ) {
    emit(const TruckDetailInitial());
  }
}
