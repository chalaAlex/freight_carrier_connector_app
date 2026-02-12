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

/// Event to trigger search functionality
class SearchTrucks extends TruckEvent {
  final String query;

  const SearchTrucks(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to apply filters to the truck list
class FilterTrucks extends TruckEvent {
  final TruckFilter filter;

  const FilterTrucks(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Event to clear all active filters
class ClearFilters extends TruckEvent {}
