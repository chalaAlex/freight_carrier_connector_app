import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/utils/debouncer.dart';
import 'package:clean_architecture/feature/truck_listing/domain/models/truck_filter.dart';
import '../bloc/truck_bloc.dart';
import '../bloc/truck_event.dart';
import '../bloc/truck_state.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/truck_list_view.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/empty_state_widget.dart';

class TruckListingScreen extends StatefulWidget {
  const TruckListingScreen({super.key});

  @override
  State<TruckListingScreen> createState() => _TruckListingScreenState();
}

class _TruckListingScreenState extends State<TruckListingScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  late Debouncer _searchDebouncer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController();
    _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));

    // Dispatch initial fetch event
    context.read<TruckBloc>().add(FetchInitialTrucks());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  /// Detects when user scrolls within 200px of bottom and triggers pagination
  void _onScroll() {
    if (_isNearBottom) {
      context.read<TruckBloc>().add(FetchNextPage());
    }
  }

  /// Checks if scroll position is within 200px of the bottom
  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll - 200);
  }

  /// Handles pull-to-refresh action
  Future<void> _onRefresh() async {
    context.read<TruckBloc>().add(RefreshTrucks());

    // Wait for the refresh to complete
    await context.read<TruckBloc>().stream.firstWhere(
      (state) => state is! TruckLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(StringManager.truckListingTitle),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      color: AppColors.primary,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _searchDebouncer.run(() {
            context.read<TruckBloc>().add(SearchTrucks(value));
          });
        },
        decoration: InputDecoration(
          hintText: StringManager.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<TruckBloc>().add(const SearchTrucks(''));
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeManager.r12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: SizeManager.s16,
            vertical: SizeManager.s12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return BlocBuilder<TruckBloc, TruckState>(
      builder: (context, state) {
        final activeFilter =
            state is TruckSuccess ? state.activeFilter : const TruckFilter();

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeManager.s16,
            vertical: SizeManager.s12,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: StringManager.filterAll,
                  filterType: FilterType.all,
                  isSelected: activeFilter.type == FilterType.all,
                  activeFilter: activeFilter,
                ),
                const SizedBox(width: SizeManager.s8),
                _buildFilterChip(
                  label: StringManager.filterAvailable,
                  filterType: FilterType.available,
                  isSelected: activeFilter.type == FilterType.available,
                  activeFilter: activeFilter,
                ),
                const SizedBox(width: SizeManager.s8),
                _buildFilterChip(
                  label: StringManager.filterFlatbed,
                  filterType: FilterType.flatbed,
                  isSelected: activeFilter.type == FilterType.flatbed,
                  activeFilter: activeFilter,
                ),
                const SizedBox(width: SizeManager.s8),
                _buildFilterChip(
                  label: StringManager.filterRefrigerated,
                  filterType: FilterType.refrigerated,
                  isSelected: activeFilter.type == FilterType.refrigerated,
                  activeFilter: activeFilter,
                ),
                const SizedBox(width: SizeManager.s8),
                _buildFilterChip(
                  label: StringManager.filterDryVan,
                  filterType: FilterType.dryVan,
                  isSelected: activeFilter.type == FilterType.dryVan,
                  activeFilter: activeFilter,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required FilterType filterType,
    required bool isSelected,
    required TruckFilter activeFilter,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        final newFilter = activeFilter.copyWith(
          type: selected ? filterType : FilterType.all,
        );
        context.read<TruckBloc>().add(FilterTrucks(newFilter));
      },
      backgroundColor: AppColors.white,
      // ignore: deprecated_member_use
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.darkGrey,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.lightGrey,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<TruckBloc, TruckState>(
      builder: (context, state) {
        if (state is TruckInitial || state is TruckLoading) {
          return const ShimmerLoader();
        }
        if (state is TruckError) {
          return ErrorRetryWidget(
            message: state.message,
            onRetry: () {
              context.read<TruckBloc>().add(FetchInitialTrucks());
            },
          );
        }
        if (state is TruckSuccess) {
          final trucks = state.trucks.data ?? [];

          if (trucks.isEmpty) {
            // Show different messages for empty data vs no results from filters
            return state.activeFilter.hasActiveFilters
                ? _buildNoResultsWidget()
                : const EmptyStateWidget();
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: TruckListView(
              trucks: trucks,
              scrollController: _scrollController,
              onEndReached: () {
                context.read<TruckBloc>().add(FetchNextPage());
              },
              currentState: state,
            ),
          );
        }
        // Handle pagination loading state
        if (state is TruckPaginationLoading) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: TruckListView(
              trucks: state.currentTrucks.data ?? [],
              scrollController: _scrollController,
              onEndReached: () {},
              currentState: state,
            ),
          );
        }

        // Handle pagination error state
        if (state is TruckPaginationError) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: Column(
              children: [
                Expanded(
                  child: TruckListView(
                    trucks: state.currentTrucks.data ?? [],
                    scrollController: _scrollController,
                    onEndReached: () {},
                    currentState: state,
                  ),
                ),
                _buildPaginationError(state.message),
              ],
            ),
          );
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }

  Widget _buildPaginationError(String message) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      // ignore: deprecated_member_use
      color: AppColors.error.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: SizeManager.s8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<TruckBloc>().add(FetchNextPage());
            },
            child: const Text(
              StringManager.retry,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the no results widget when filters return empty results
  Widget _buildNoResultsWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SizeManager.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: SizeManager.s16),
            Text(
              StringManager.noResultsFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: SizeManager.s8),
            Text(
              StringManager.tryDifferentFilters,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SizeManager.s24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                context.read<TruckBloc>().add(ClearFilters());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeManager.s24,
                  vertical: SizeManager.s12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeManager.r12),
                ),
              ),
              child: const Text(StringManager.clearFilters),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the floating action button for posting freight
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // TODO: Navigate to post freight screen
      },
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      icon: const Icon(Icons.add),
      label: const Text(StringManager.postFreight),
    );
  }
}
