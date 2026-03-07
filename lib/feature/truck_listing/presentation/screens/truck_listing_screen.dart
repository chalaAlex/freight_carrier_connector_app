import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/core/utils/debouncer.dart';
import 'package:clean_architecture/feature/truck_listing/domain/models/truck_filter.dart';
import '../bloc/truck_bloc.dart';
import '../bloc/truck_event.dart';
import '../bloc/truck_state.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/truck_card.dart';
import '../widgets/pagination_loader.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocBuilder<TruckBloc, TruckState>(
        builder: (context, state) {
          if (state is TruckInitial || state is TruckLoading) {
            return _buildLoadingState(colorScheme);
          }
          if (state is TruckError) {
            return _buildErrorState(state.message, colorScheme);
          }

          return _buildSuccessState(state, colorScheme);
        },
      ),
    );
  }

  Widget _buildLoadingState(AppColorScheme colorScheme) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(colorScheme),
        _buildSliverFilterChips(const TruckFilter(), colorScheme),
        const SliverFillRemaining(child: ShimmerLoader()),
      ],
    );
  }

  Widget _buildErrorState(String message, AppColorScheme colorScheme) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(colorScheme),
        _buildSliverFilterChips(const TruckFilter(), colorScheme),
        SliverFillRemaining(
          child: ErrorRetryWidget(
            message: message,
            onRetry: () {
              context.read<TruckBloc>().add(FetchInitialTrucks());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(TruckState state, AppColorScheme colorScheme) {
    final trucks = _getTrucks(state);
    final activeFilter = _getActiveFilter(state);
    final showPaginationLoader = state is TruckPaginationLoading;

    if (trucks.isEmpty) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(colorScheme),
          _buildSliverFilterChips(activeFilter, colorScheme),
          SliverFillRemaining(
            child: activeFilter.hasActiveFilters
                ? _buildNoResultsWidget(colorScheme)
                : const EmptyStateWidget(),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(colorScheme),
          _buildSliverFilterChips(activeFilter, colorScheme),
          SliverPadding(
            padding: const EdgeInsets.all(SizeManager.s16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == trucks.length && showPaginationLoader) {
                  return const PaginationLoader();
                }

                final truck = trucks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: SizeManager.s16),
                  child: TruckCard(
                    truck: truck,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.truckDetailRoute,
                        arguments: truck.id,
                      );
                    },
                    index: index,
                  ),
                );
              }, childCount: trucks.length + (showPaginationLoader ? 1 : 0)),
            ),
          ),
          if (state is TruckPaginationError)
            SliverToBoxAdapter(
              child: _buildPaginationError(state.message, colorScheme),
            ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(AppColorScheme colorScheme) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.textPrimary,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.all(SizeManager.s16),
          color: colorScheme.surface,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _searchDebouncer.run(() {
                context.read<TruckBloc>().add(SearchTrucks(value));
              });
            },
            style: TextStyle(fontSize: 14, color: colorScheme.textPrimary),
            decoration: InputDecoration(
              hintText: StringManager.searchHint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: colorScheme.textSecondary,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: colorScheme.textSecondary,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color: colorScheme.textSecondary,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        context.read<TruckBloc>().add(const SearchTrucks(''));
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.border,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SizeManager.r12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: SizeManager.s12,
                vertical: SizeManager.s8,
              ),
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverFilterChips(
    TruckFilter activeFilter,
    AppColorScheme colorScheme,
  ) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _FilterChipsDelegate(
        activeFilter: activeFilter,
        colorScheme: colorScheme,
        onFilterChanged: (filter) {
          context.read<TruckBloc>().add(FilterTrucks(filter));
        },
      ),
    );
  }

  List<dynamic> _getTrucks(TruckState state) {
    if (state is TruckSuccess) {
      return state.trucks.trucks ?? [];
    } else if (state is TruckPaginationLoading) {
      return state.currentTrucks.trucks ?? [];
    } else if (state is TruckPaginationError) {
      return state.currentTrucks.trucks ?? [];
    }
    return [];
  }

  TruckFilter _getActiveFilter(TruckState state) {
    if (state is TruckSuccess) {
      return state.activeFilter;
    }
    return const TruckFilter();
  }

  Widget _buildPaginationError(String message, AppColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      color: AppColors.error.withValues(alpha: 0.1),
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

  Widget _buildNoResultsWidget(AppColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SizeManager.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: colorScheme.border),
            const SizedBox(height: SizeManager.s16),
            Text(
              StringManager.noResultsFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.textPrimary,
              ),
            ),
            const SizedBox(height: SizeManager.s8),
            Text(
              StringManager.tryDifferentFilters,
              style: TextStyle(fontSize: 14, color: colorScheme.textSecondary),
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
}

// Custom delegate for pinned filter chips
class _FilterChipsDelegate extends SliverPersistentHeaderDelegate {
  final TruckFilter activeFilter;
  final AppColorScheme colorScheme;
  final Function(TruckFilter) onFilterChanged;

  _FilterChipsDelegate({
    required this.activeFilter,
    required this.colorScheme,
    required this.onFilterChanged,
  });

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s16,
        vertical: SizeManager.s8,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: StringManager.filterAll,
              filterType: FilterType.all,
              isSelected: activeFilter.type == FilterType.all,
            ),
            const SizedBox(width: SizeManager.s8),
            _buildFilterChip(
              label: StringManager.filterAvailable,
              filterType: FilterType.available,
              isSelected: activeFilter.type == FilterType.available,
            ),
            const SizedBox(width: SizeManager.s8),
            _buildFilterChip(
              label: StringManager.filterFlatbed,
              filterType: FilterType.flatbed,
              isSelected: activeFilter.type == FilterType.flatbed,
            ),
            const SizedBox(width: SizeManager.s8),
            _buildFilterChip(
              label: StringManager.filterRefrigerated,
              filterType: FilterType.refrigerated,
              isSelected: activeFilter.type == FilterType.refrigerated,
            ),
            const SizedBox(width: SizeManager.s8),
            _buildFilterChip(
              label: StringManager.filterDryVan,
              filterType: FilterType.dryVan,
              isSelected: activeFilter.type == FilterType.dryVan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required FilterType filterType,
    required bool isSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        final newFilter = activeFilter.copyWith(
          type: selected ? filterType : FilterType.all,
        );
        onFilterChanged(newFilter);
      },
      backgroundColor: colorScheme.surface,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : colorScheme.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeManager.r12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : colorScheme.border,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_FilterChipsDelegate oldDelegate) {
    return activeFilter != oldDelegate.activeFilter ||
        colorScheme != oldDelegate.colorScheme;
  }
}
