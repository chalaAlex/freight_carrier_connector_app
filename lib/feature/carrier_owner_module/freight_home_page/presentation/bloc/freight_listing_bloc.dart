import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/usecase/get_freights_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'freight_listing_event.dart';
import 'freight_listing_state.dart';

const _pageSize = 10;

class FreightListingBloc
    extends Bloc<FreightListingEvent, FreightListingState> {
  final GetFreightsUseCase getFreightsUseCase;

  FreightListingBloc({required this.getFreightsUseCase})
    : super(FreightListingInitial()) {
    on<FetchFreightListing>(_onFetch);
    on<ApplyFreightFilter>(_onApplyFilter);
    on<ClearFreightFilter>(_onClearFilter);
    on<LoadMoreFreights>(_onLoadMore);
    on<RefreshFreightListing>(_onRefresh);
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  FreightFilter _currentFilter() {
    final s = state;
    if (s is FreightListingSuccess) return s.activeFilter;
    if (s is FreightListingError) return s.activeFilter;
    return const FreightFilter();
  }

  Future<void> _fetchPage(
    Emitter<FreightListingState> emit,
    int page,
    FreightFilter filter,
  ) async {
    final result = await getFreightsUseCase(
      GetFreightsParams(page: page, limit: _pageSize, filter: filter),
    );
    result.fold(
      (failure) =>
          emit(FreightListingError(failure.message, activeFilter: filter)),
      (response) {
        final items = response.freights ?? [];
        emit(
          FreightListingSuccess(
            freights: items,
            currentPage: page,
            hasMore: items.length >= _pageSize,
            activeFilter: filter,
          ),
        );
      },
    );
  }

  // ── handlers ─────────────────────────────────────────────────────────────

  Future<void> _onFetch(
    FetchFreightListing event,
    Emitter<FreightListingState> emit,
  ) async {
    final filter = event.filter ?? const FreightFilter();
    emit(FreightListingLoading());
    await _fetchPage(emit, 1, filter);
  }

  Future<void> _onApplyFilter(
    ApplyFreightFilter event,
    Emitter<FreightListingState> emit,
  ) async {
    emit(FreightListingLoading());
    await _fetchPage(emit, 1, event.filter);
  }

  Future<void> _onClearFilter(
    ClearFreightFilter event,
    Emitter<FreightListingState> emit,
  ) async {
    emit(FreightListingLoading());
    await _fetchPage(emit, 1, const FreightFilter());
  }

  Future<void> _onLoadMore(
    LoadMoreFreights event,
    Emitter<FreightListingState> emit,
  ) async {
    final current = state;
    if (current is! FreightListingSuccess) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.currentPage + 1;
    final result = await getFreightsUseCase(
      GetFreightsParams(
        page: nextPage,
        limit: _pageSize,
        filter: current.activeFilter,
      ),
    );
    result.fold((failure) => emit(current.copyWith(isLoadingMore: false)), (
      response,
    ) {
      final newItems = response.freights ?? [];
      emit(
        FreightListingSuccess(
          freights: [...current.freights, ...newItems],
          currentPage: nextPage,
          hasMore: newItems.length >= _pageSize,
          activeFilter: current.activeFilter,
        ),
      );
    });
  }

  Future<void> _onRefresh(
    RefreshFreightListing event,
    Emitter<FreightListingState> emit,
  ) async {
    final filter = _currentFilter();
    final current = state;
    if (current is FreightListingSuccess) {
      emit(current.copyWith(isRefreshing: true, isLoadingMore: false));
    } else {
      emit(FreightListingLoading());
    }
    await _fetchPage(emit, 1, filter);
  }
}
