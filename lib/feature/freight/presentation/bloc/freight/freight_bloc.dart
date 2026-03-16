// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/create_freight_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_freight_detail_usecase.dart';
import 'package:clean_architecture/feature/freight/domain/usecases/get_freights_usecase.dart';
import 'freight_event.dart';
import 'freight_state.dart';

class FreightBloc extends Bloc<FreightEvent, FreightState> {
  final CreateFreightUseCase createFreightUseCase;
  final GetFreightsUseCase getFreightsUseCase;
  final GetFreightDetailUseCase getFreightDetailUseCase;

  FreightBloc({
    required this.createFreightUseCase,
    required this.getFreightsUseCase,
    required this.getFreightDetailUseCase,
  }) : super(FreightInitial()) {
    on<CreateFreightEvent>(_onCreateFreight);
    on<FetchFreightsEvent>(_onFetchFreights);
    on<FetchFreightDetailEvent>(_onFetchFreightDetail);
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

  Future<void> _onFetchFreightDetail(
    FetchFreightDetailEvent event,
    Emitter<FreightState> emit,
  ) async {
    emit(FreightLoading());
    print("??????????????/ ${event.id}");
    final result = await getFreightDetailUseCase(event.id);
    result.fold(
      (Failure failure) => emit(FreightError(failure.message)),
      (response) => emit(FreightDetailSuccess(response)),
    );
  }
}
