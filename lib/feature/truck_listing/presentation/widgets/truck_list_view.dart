import 'package:flutter/material.dart';
import '../../domain/entities/truck.dart';
import '../bloc/truck_state.dart';
import 'truck_card.dart';
import 'pagination_loader.dart';

/// A scrollable list view that efficiently renders truck cards.
///
/// Uses [ListView.builder] for optimal performance with large lists.
/// Displays a [TruckCard] for each truck and appends a [PaginationLoader]
/// when more pages are being loaded.
///
/// The [scrollController] is used to detect scroll position for pagination,
/// and [onEndReached] callback is triggered when user scrolls near the bottom.
class TruckListView extends StatelessWidget {
  final List<Truck> trucks;
  final ScrollController scrollController;
  final VoidCallback onEndReached;
  final TruckState? currentState;

  const TruckListView({
    super.key,
    required this.trucks,
    required this.scrollController,
    required this.onEndReached,
    this.currentState,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we should show pagination loader
    final bool showPaginationLoader = currentState is TruckPaginationLoading;
    
    // Calculate total item count (trucks + optional pagination loader)
    final int itemCount = trucks.length + (showPaginationLoader ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Show pagination loader at the end if loading more pages
        if (index == trucks.length && showPaginationLoader) {
          return const PaginationLoader();
        }

        // Render truck card
        final truck = trucks[index];
        return TruckCard(
          truck: truck,
          onTap: () {
            // TODO: Navigate to truck details screen
          },
        );
      },
    );
  }
}
