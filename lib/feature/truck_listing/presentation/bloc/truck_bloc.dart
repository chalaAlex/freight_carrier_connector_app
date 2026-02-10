import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/domain/usecases/get_trucks_usecase.dart';
import 'truck_event.dart';
import 'truck_state.dart';

class TruckBloc extends Bloc<TruckEvent, TruckState> {
  final GetTrucksUseCase getTrucksUseCase;
  static const int trucksPerPage = 10;

  TruckBloc(this.getTrucksUseCase) : super(TruckInitial()) {
    on<FetchInitialTrucks>(_onFetchInitialTrucks);
    on<RefreshTrucks>(_onRefreshTrucks);
    on<FetchNextPage>(_onFetchNextPage);
  }

  Future<void> _onFetchInitialTrucks(FetchInitialTrucks event, Emitter<TruckState> emit) async {
    emit(TruckLoading());
    
    final result = await getTrucksUseCase(1);

    final trucks = result.fold((failure) {
      emit(TruckError(failure.message));
      return null;
    }, (trucks) => trucks);

    if (trucks == null) {
      return;
    }

    emit(
      TruckSuccess(
        trucks: trucks,
        currentPage: 1,
        hasMorePages: trucks.data?.length == trucksPerPage,
      ),
    );
  }

  Future<void> _onRefreshTrucks(
    RefreshTrucks event,
    Emitter<TruckState> emit,
  ) async {
    emit(TruckLoading());
    final result = await getTrucksUseCase(1);

    result.fold(
      (Failure failure) => emit(TruckError(failure.message)),
      (trucks) => emit(
        TruckSuccess(
          trucks: trucks,
          currentPage: 1,
          hasMorePages: trucks.data?.length == trucksPerPage,
        ),
      ),
    );
  }

  Future<void> _onFetchNextPage(
    FetchNextPage event,
    Emitter<TruckState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TruckSuccess || !currentState.hasMorePages) {
      return;
    }

    emit(TruckPaginationLoading(currentState.trucks));

    final nextPage = currentState.currentPage + 1;
    final result = await getTrucksUseCase(nextPage);

    result.fold(
      (Failure failure) =>
          emit(TruckPaginationError(currentState.trucks, failure.message)),
      (newTrucks) {
        final mergedData = [...?currentState.trucks.data, ...?newTrucks.data];
        final allTrucks = TruckBaseResponseEntity(
          statusCode: newTrucks.statusCode ?? currentState.trucks.statusCode,
          message: newTrucks.message ?? currentState.trucks.message,
          total: newTrucks.total ?? currentState.trucks.total,
          data: mergedData,
        );
        emit(
          TruckSuccess(
            trucks: allTrucks,
            currentPage: nextPage,
            hasMorePages: newTrucks.data?.length == trucksPerPage,
          ),
        );
      },
    );
  }
}
