// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/domain/usecases/get_trucks_usecase.dart';
import 'package:clean_architecture/feature/truck_listing/domain/models/truck_filter.dart';
import 'truck_event.dart';
import 'truck_state.dart';

class TruckBloc extends Bloc<TruckEvent, TruckState> {
  final GetTrucksUseCase getTrucksUseCase;
  static const int trucksPerPage = 10;

  TruckBloc(this.getTrucksUseCase) : super(TruckInitial()) {
    on<FetchInitialTrucks>(_onFetchInitialTrucks);
    on<RefreshTrucks>(_onRefreshTrucks);
    on<FetchNextPage>(_onFetchNextPage);
    on<SearchTrucks>(_onSearchTrucks);
    on<FilterTrucks>(_onFilterTrucks);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onFetchInitialTrucks(
    FetchInitialTrucks event,
    Emitter<TruckState> emit,
  ) async {
    emit(TruckLoading());

    final result = await getTrucksUseCase(const GetTrucksParams(page: 1));

    result.fold(
      (failure) => emit(TruckError(failure.message)),
      (trucks) => emit(
        TruckSuccess(
          trucks: trucks,
          currentPage: 1,
          hasMorePages: trucks.data?.length == trucksPerPage,
        ),
      ),
    );
  }

  Future<void> _onRefreshTrucks(
    RefreshTrucks event,
    Emitter<TruckState> emit,
  ) async {
    final currentState = state;
    final activeFilter = currentState is TruckSuccess
        ? currentState.activeFilter
        : const TruckFilter();

    emit(TruckLoading());

    final result = await getTrucksUseCase(
      GetTrucksParams(
        page: 1,
        search: activeFilter.searchQuery.isNotEmpty
            ? activeFilter.searchQuery
            : null,
        company: null, // Can be added later if needed
        isAvailable: activeFilter.type == FilterType.available ? true : null,
        carrierType: _getCarrierTypeString(activeFilter.type),
      ),
    );

    result.fold(
      (Failure failure) => emit(TruckError(failure.message)),
      (trucks) => emit(
        TruckSuccess(
          trucks: trucks,
          currentPage: 1,
          hasMorePages: trucks.data?.length == trucksPerPage,
          activeFilter: activeFilter,
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
    final result = await getTrucksUseCase(
      GetTrucksParams(
        page: nextPage,
        search: currentState.activeFilter.searchQuery.isNotEmpty
            ? currentState.activeFilter.searchQuery
            : null,
        company: null,
        isAvailable: currentState.activeFilter.type == FilterType.available
            ? true
            : null,
        carrierType: _getCarrierTypeString(currentState.activeFilter.type),
      ),
    );

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
            activeFilter: currentState.activeFilter,
          ),
        );
      },
    );
  }

  Future<void> _onSearchTrucks(
    SearchTrucks event,
    Emitter<TruckState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TruckSuccess) return;

    final updatedFilter = currentState.activeFilter.copyWith(
      searchQuery: event.query,
    );

    // Trigger new API call with search query
    emit(TruckLoading());

    final result = await getTrucksUseCase(
      GetTrucksParams(
        page: 1,
        search: event.query.isNotEmpty ? event.query : null,
        company: null,
        isAvailable:
            updatedFilter.type == FilterType.available ? true : null,
        carrierType: _getCarrierTypeString(updatedFilter.type),
      ),
    );

    result.fold(
      (failure) => emit(TruckError(failure.message)),
      (trucks) => emit(
        TruckSuccess(
          trucks: trucks,
          currentPage: 1,
          hasMorePages: trucks.data?.length == trucksPerPage,
          activeFilter: updatedFilter,
        ),
      ),
    );
  }

  Future<void> _onFilterTrucks(
    FilterTrucks event,
    Emitter<TruckState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TruckSuccess) return;

    // Trigger new API call with filter
    emit(TruckLoading());

    final result = await getTrucksUseCase(
      GetTrucksParams(
        page: 1,
        search: event.filter.searchQuery.isNotEmpty
            ? event.filter.searchQuery
            : null,
        company: null,
        isAvailable: event.filter.type == FilterType.available ? true : null,
        carrierType: _getCarrierTypeString(event.filter.type),
      ),
    );

    result.fold(
      (failure) => emit(TruckError(failure.message)),
      (trucks) => emit(
        TruckSuccess(
          trucks: trucks,
          currentPage: 1,
          hasMorePages: trucks.data?.length == trucksPerPage,
          activeFilter: event.filter,
        ),
      ),
    );
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<TruckState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TruckSuccess) return;

    const emptyFilter = TruckFilter();

    // Trigger new API call without filters
    emit(TruckLoading());

    final result = await getTrucksUseCase(const GetTrucksParams(page: 1));

    result.fold(
      (failure) => emit(TruckError(failure.message)),
      (trucks) => emit(
        TruckSuccess(
          trucks: trucks,
          currentPage: 1,
          hasMorePages: trucks.data?.length == trucksPerPage,
          activeFilter: emptyFilter,
        ),
      ),
    );
  }

  /// Converts FilterType to carrierType string for API
  String? _getCarrierTypeString(FilterType type) {
    switch (type) {
      case FilterType.flatbed:
        return 'flatbed';
      case FilterType.refrigerated:
        return 'refrigerated';
      case FilterType.dryVan:
        return 'dryVan';
      case FilterType.available:
      case FilterType.all:
        return null;
    }
  }
}
