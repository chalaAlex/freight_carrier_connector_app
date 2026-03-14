import 'package:equatable/equatable.dart';
import '../../domain/models/truck_filter.dart';

abstract class TruckEvent extends Equatable {
  const TruckEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialTrucks extends TruckEvent {}

class RefreshTrucks extends TruckEvent {}

class FetchNextPage extends TruckEvent {}

/// Apply a new filter set (resets to page 1 automatically).
class ApplyTruckFilter extends TruckEvent {
  final TruckFilter filter;

  const ApplyTruckFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Clear all active filters and reload from page 1.
class ResetTruckFilters extends TruckEvent {}
