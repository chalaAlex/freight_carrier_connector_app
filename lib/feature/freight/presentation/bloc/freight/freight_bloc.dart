// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/create_freight_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_freights_usecase.dart';
import 'freight_event.dart';
import 'freight_state.dart';

class FreightBloc extends Bloc<FreightEvent, FreightState> {
  final CreateFreightUseCase createFreightUseCase;
  final GetFreightsUseCase getFreightsUseCase;

  FreightBloc({
    required this.createFreightUseCase,
    required this.getFreightsUseCase,
  }) : super(FreightInitial()) {
    on<CreateFreightEvent>(_onCreateFreight);
    on<FetchFreightsEvent>(_onFetchFreights);
  }

  Future<void> _onCreateFreight(
    CreateFreightEvent event,
    Emitter<FreightState> emit,
  ) async {
    emit(FreightLoading());

    final result = await createFreightUseCase(event.request);

    result.fold(
      (Failure failure) => emit(FreightError(failure.message)),
      (response) => emit(FreightCreateSuccess(response)),
    );
  }

  Future<void> _onFetchFreights(
    FetchFreightsEvent event,
    Emitter<FreightState> emit,
  ) async {
    emit(FreightLoading());

    final result = await getFreightsUseCase(event.page);

    result.fold(
      (Failure failure) => emit(FreightError(failure.message)),
      (response) => emit(FreightFetchSuccess(response)),
    );
  }
}
