import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/truck_detail/truck_detail_bloc.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/truck_detail/truck_detail_event.dart';
import 'package:clean_architecture/feature/freight/presentation/bloc/truck_detail/truck_detail_state.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_content.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_error.dart';
import 'package:clean_architecture/feature/freight/presentation/widgets/truck_detail/truck_detail_loading.dart';

class TruckDetailScreen extends StatefulWidget {
  final String truckId;

  const TruckDetailScreen({super.key, required this.truckId});

  @override
  State<TruckDetailScreen> createState() => _TruckDetailScreenState();
}

class _TruckDetailScreenState extends State<TruckDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch event to fetch truck details
    context.read<TruckDetailBloc>().add(FetchTruckDetailEvent(widget.truckId));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = isDarkMode ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocBuilder<TruckDetailBloc, TruckDetailState>(
        builder: (context, state) {
          if (state is TruckDetailLoading) {
            return const TruckDetailLoadingWidget();
          } else if (state is TruckDetailLoaded) {
            final truck = state.truckDetail.data?.truck;
            if (truck == null) {
              return const TruckDetailErrorWidget(
                message: 'Truck data not available',
              );
            }
            return TruckDetailContent(truck: truck);
          } else if (state is TruckDetailError) {
            return TruckDetailErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<TruckDetailBloc>().add(
                  FetchTruckDetailEvent(widget.truckId),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
