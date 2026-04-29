import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freights_entity.dart';
import 'package:equatable/equatable.dart';

abstract class FreightListingState extends Equatable {
  const FreightListingState();

  @override
  List<Object?> get props => [];
}

class FreightListingInitial extends FreightListingState {}

class FreightListingLoading extends FreightListingState {}

class FreightListingSuccess extends FreightListingState {
  final List<FreightEntity> freights;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final FreightFilter activeFilter;

  const FreightListingSuccess({
    required this.freights,
    required this.currentPage,
    required this.hasMore,
    required this.activeFilter,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  FreightListingSuccess copyWith({
    List<FreightEntity>? freights,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    FreightFilter? activeFilter,
  }) {
    return FreightListingSuccess(
      freights: freights ?? this.freights,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [
    freights,
    currentPage,
    hasMore,
    isLoadingMore,
    isRefreshing,
    activeFilter,
  ];
}

class FreightListingError extends FreightListingState {
  final String message;
  final FreightFilter activeFilter;

  const FreightListingError(
    this.message, {
    this.activeFilter = const FreightFilter(),
  });

  @override
  List<Object?> get props => [message, activeFilter];
}
