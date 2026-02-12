import 'package:equatable/equatable.dart';

/// Enum representing different filter types for truck listing
enum FilterType {
  all,
  available,
  flatbed,
  refrigerated,
  dryVan,
}

/// Model class representing filter criteria for truck listing
/// 
/// This class encapsulates all possible filter options including:
/// - Filter type (availability, truck type)
/// - Search query
/// - Capacity range
/// - Price range
class TruckFilter extends Equatable {
  /// The type of filter to apply (all, available, or specific truck type)
  final FilterType type;
  
  /// Search query to match against model, company, and location
  final String searchQuery;
  
  /// Minimum capacity in tons (optional)
  final double? minCapacity;
  
  /// Maximum capacity in tons (optional)
  final double? maxCapacity;
  
  /// Minimum price per day (optional)
  final double? minPricePerDay;
  
  /// Maximum price per day (optional)
  final double? maxPricePerDay;

  const TruckFilter({
    this.type = FilterType.all,
    this.searchQuery = '',
    this.minCapacity,
    this.maxCapacity,
    this.minPricePerDay,
    this.maxPricePerDay,
  });

  /// Returns true if any filters are currently active
  bool get hasActiveFilters =>
      type != FilterType.all ||
      searchQuery.isNotEmpty ||
      minCapacity != null ||
      maxCapacity != null ||
      minPricePerDay != null ||
      maxPricePerDay != null;

  /// Creates a copy of this filter with the given fields replaced
  TruckFilter copyWith({
    FilterType? type,
    String? searchQuery,
    double? minCapacity,
    double? maxCapacity,
    double? minPricePerDay,
    double? maxPricePerDay,
  }) {
    return TruckFilter(
      type: type ?? this.type,
      searchQuery: searchQuery ?? this.searchQuery,
      minCapacity: minCapacity ?? this.minCapacity,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      minPricePerDay: minPricePerDay ?? this.minPricePerDay,
      maxPricePerDay: maxPricePerDay ?? this.maxPricePerDay,
    );
  }

  @override
  List<Object?> get props => [
        type,
        searchQuery,
        minCapacity,
        maxCapacity,
        minPricePerDay,
        maxPricePerDay,
      ];
}
