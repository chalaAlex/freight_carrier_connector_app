import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/routes_manager.dart';
import '../../domain/entities/truck_entity.dart';
import '../bloc/truck_state.dart';
import 'truck_card.dart';
import 'pagination_loader.dart';

class TruckListView extends StatelessWidget {
  final List<TruckEntity> trucks;
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
    final bool showPaginationLoader = currentState is TruckPaginationLoading;
    final int itemCount = trucks.length + (showPaginationLoader ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == trucks.length && showPaginationLoader) {
          return const PaginationLoader();
        }

        final truck = trucks[index];

        return TruckCard(
          truck: truck,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.truckDetailRoute,
              arguments: truck.id,
            );
          },
          index: index,
        );
      },
    );
  }
}
