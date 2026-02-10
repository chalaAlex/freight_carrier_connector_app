import 'package:equatable/equatable.dart';
import '../../domain/entities/truck.dart';

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

  const TruckSuccess({
    required this.trucks,
    required this.currentPage,
    required this.hasMorePages,
  });

  @override
  List<Object?> get props => [trucks, currentPage, hasMorePages];

  TruckSuccess copyWith({
    TruckBaseResponseEntity? trucks,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return TruckSuccess(
      trucks: trucks ?? this.trucks,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}

class TruckError extends TruckState {
  final String message;

  const TruckError(this.message);

  @override
  List<Object?> get props => [message];
}

class TruckPaginationLoading extends TruckState {
  final TruckBaseResponseEntity currentTrucks;

  const TruckPaginationLoading(this.currentTrucks);

  @override
  List<Object?> get props => [currentTrucks];
}

class TruckPaginationError extends TruckState {
  final TruckBaseResponseEntity currentTrucks;
  final String message;

  const TruckPaginationError(this.currentTrucks, this.message);

  @override
  List<Object?> get props => [currentTrucks, message];
}
