import 'package:bloc/bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/entities/truck_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/models/truck_filter.dart';
import 'package:clean_architecture/feature/freight_oner_module/truck_listing/domain/usecases/get_trucks_usecase.dart';
import 'truck_event.dart';
import 'truck_state.dart';

class TruckBloc extends Bloc<TruckEvent, TruckState> {
  final GetTrucksUseCase getTrucksUseCase;
  static const int _perPage = 10;

  TruckBloc(this.getTrucksUseCase) : super(TruckInitial()) {
    on<FetchInitialTrucks>(_onFetchInitial);
    // on<SearchTruck>(_onSearchTrucks);
    on<RefreshTrucks>(_onRefresh);
    on<FetchNextPage>(_onFetchNextPage);
    on<ApplyTruckFilter>(_onApplyFilter);
    on<ResetTruckFilters>(_onResetFilters);
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  TruckFilter _currentFilter() {
    final s = state;
    if (s is TruckSuccess) return s.activeFilter;
    if (s is TruckPaginationLoading) return s.activeFilter;
    if (s is TruckPaginationError) return s.activeFilter;
    return const TruckFilter();
  }

  Future<void> _fetch({
    required TruckFilter filter,
    required Emitter<TruckState> emit,
    bool paginating = false,
    TruckBaseResponseEntity? existing,
  }) async {
    if (!paginating) {
      emit(TruckLoading());
    } else {
      emit(TruckPaginationLoading(existing!, filter));
    }

    final result = await getTrucksUseCase(filter);

    result.fold(
      (failure) {
        if (paginating) {
          emit(TruckPaginationError(existing!, failure.message, filter));
        } else {
          emit(TruckError(failure.message));
        }
      },
      (newTrucks) {
        final merged = paginating
            ? [...?existing!.trucks, ...?newTrucks.trucks]
            : (newTrucks.trucks ?? []);

        final allTrucks = TruckBaseResponseEntity(
          statusCode: newTrucks.statusCode,
          message: newTrucks.message,
          total: newTrucks.total,
          trucks: merged,
        );

        emit(
          TruckSuccess(
            trucks: allTrucks,
            currentPage: filter.page,
            hasMorePages: (newTrucks.trucks?.length ?? 0) == _perPage,
            activeFilter: filter,
          ),
        );
      },
    );
  }

  // ── handlers ─────────────────────────────────────────────────────────────

  Future<void> _onFetchInitial(
    FetchInitialTrucks event,
    Emitter<TruckState> emit,
  ) async {
    await _fetch(filter: const TruckFilter(page: 1), emit: emit);
  }

// Future<void> __onSerachTrucks( 
//   SearchTruck event,
//   Emitter<_onSearchTrucks> emit,
// ) { 

// }

  Future<void> _onRefresh(RefreshTrucks event, Emitter<TruckState> emit) async {
    final filter = _currentFilter().copyWith(page: 1);
    await _fetch(filter: filter, emit: emit);
  }

  Future<void> _onFetchNextPage(
    FetchNextPage event,
    Emitter<TruckState> emit,
  ) async {
    final s = state;
    if (s is! TruckSuccess || !s.hasMorePages) return;

    final nextFilter = s.activeFilter.copyWith(page: s.currentPage + 1);
    await _fetch(
      filter: nextFilter,
      emit: emit,
      paginating: true,
      existing: s.trucks,
    );
  }

  Future<void> _onApplyFilter(
    ApplyTruckFilter event,
    Emitter<TruckState> emit,
  ) async {
    // Always reset to page 1 when filters change
    final filter = event.filter.copyWith(page: 1);
    await _fetch(filter: filter, emit: emit);
  }

  Future<void> _onResetFilters(
    ResetTruckFilters event,
    Emitter<TruckState> emit,
  ) async {
    await _fetch(filter: const TruckFilter(page: 1), emit: emit);
  }
}
