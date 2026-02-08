import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import '../../domain/entities/truck.dart';
import '../bloc/truck_bloc.dart';
import '../bloc/truck_event.dart';
import '../bloc/truck_state.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/truck_list_view.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/empty_state_widget.dart';

/// Main screen for displaying the truck listing feature.
///
/// This screen implements:
/// - Initial loading with shimmer effect
/// - Pull-to-refresh functionality
/// - Infinite scroll pagination
/// - Error handling with retry
/// - Empty state display
/// - Search bar and filter chips
/// - Floating action button for posting freight
///
/// The screen uses [TruckBloc] for state management and follows Clean Architecture principles.
class TruckListingScreen extends StatefulWidget {
  const TruckListingScreen({super.key});

  @override
  State<TruckListingScreen> createState() => _TruckListingScreenState();
}

class _TruckListingScreenState extends State<TruckListingScreen> {
  late ScrollController _scrollController;
  String _selectedFilter = StringManager.filterAll;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    // Dispatch initial fetch event
    context.read<TruckBloc>().add(FetchInitialTrucks());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Builds the app bar with branding
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(StringManager.truckListingTitle),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
    );
  }

  /// Builds the search bar below the app bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      color: AppColors.primary,
      child: TextField(
        decoration: InputDecoration(
          hintText: StringManager.searchHint,
          prefixIcon: const Icon(Icons.search),
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

  /// Builds the filter chips row
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeManager.s16,
        vertical: SizeManager.s12,
      ),
      child: Row(
        children: [
          _buildFilterChip(StringManager.filterAll),
          const SizedBox(width: SizeManager.s8),
          _buildFilterChip(StringManager.filterAvailable),
          const SizedBox(width: SizeManager.s8),
          _buildFilterChip(StringManager.filterRefrigerated),
        ],
      ),
    );
  }

  /// Builds an individual filter chip
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
        // TODO: Implement filtering logic
      },
      backgroundColor: AppColors.white,
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

  /// Builds the main content area with state-based rendering
  Widget _buildContent() {
    return BlocBuilder<TruckBloc, TruckState>(
      builder: (context, state) {
        // Handle initial and loading states
        if (state is TruckInitial || state is TruckLoading) {
          return const ShimmerLoader();
        }

        // Handle error state
        if (state is TruckError) {
          return ErrorRetryWidget(
            message: state.message,
            onRetry: () {
              context.read<TruckBloc>().add(FetchInitialTrucks());
            },
          );
        }

        // Handle success states (including pagination states)
        if (state is TruckSuccess) {
          // Show empty state if no trucks
          if (state.trucks.isEmpty) {
            return const EmptyStateWidget();
          }

          // Show truck list with pull-to-refresh
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: TruckListView(
              trucks: state.trucks,
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
              trucks: state.currentTrucks,
              scrollController: _scrollController,
              onEndReached: () {
                // Already loading, do nothing
              },
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
                    trucks: state.currentTrucks,
                    scrollController: _scrollController,
                    onEndReached: () {
                      // Don't trigger while in error state
                    },
                    currentState: state,
                  ),
                ),
                _buildPaginationError(state.message),
              ],
            ),
          );
        }

        // Fallback for unknown states
        return const Center(
          child: Text('Unknown state'),
        );
      },
    );
  }

  /// Builds the pagination error widget at the bottom of the list
  Widget _buildPaginationError(String message) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      color: AppColors.error.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: SizeManager.s8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 14,
              ),
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
