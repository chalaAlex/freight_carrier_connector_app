import 'package:equatable/equatable.dart';
import '../../domain/entities/truck_entity.dart';
import '../../domain/models/truck_filter.dart';

abstract class TruckState extends Equatable {
  const TruckState();

  @override
  List<Object?> get props => [];
}

class TruckInitial extends TruckState {}

class TruckLoading extends TruckState {}

class TruckSuccess extends TruckState {
  final TruckBaseResponseEntity trucks;
  final int currentPage;
  final bool hasMorePages;
  final TruckFilter activeFilter;

  const TruckSuccess({
    required this.trucks,
    required this.currentPage,
    required this.hasMorePages,
    this.activeFilter = const TruckFilter(),
  });

  @override
  List<Object?> get props => [trucks, currentPage, hasMorePages, activeFilter];
}

class TruckError extends TruckState {
  final String message;

  const TruckError(this.message);

  @override
  List<Object?> get props => [message];
}

class TruckPaginationLoading extends TruckState {
  final TruckBaseResponseEntity currentTrucks;
  final TruckFilter activeFilter;

  const TruckPaginationLoading(this.currentTrucks, this.activeFilter);

  @override
  List<Object?> get props => [currentTrucks, activeFilter];
}

class TruckPaginationError extends TruckState {
  final TruckBaseResponseEntity currentTrucks;
  final String message;
  final TruckFilter activeFilter;

  const TruckPaginationError(
    this.currentTrucks,
    this.message,
    this.activeFilter,
  );

  @override
  List<Object?> get props => [currentTrucks, message, activeFilter];
}
