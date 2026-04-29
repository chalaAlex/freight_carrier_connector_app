import 'package:equatable/equatable.dart';

/// Scalable server-side filter model for truck listing.
/// Each field maps directly to a query parameter sent to the API.
class TruckFilter extends Equatable {
  /// Free-text search (matches model, company, location)
  final String? search;

  /// Filter by feature name, e.g. "Tracking System"
  final String? features;

  /// Filter by brand name, e.g. "Volvo"
  final String? brand;

  /// Filter by region name, e.g. "Oromia"
  final String? region;

  /// Filter by verification status
  final bool? isVerified;

  /// Minimum load capacity in tons (maps to capacity_gte)
  final double? loadCapacityGte;

  /// Filter by availability
  final bool? isAvailable;

  /// Filter by carrier type, e.g. "flatbed"
  final String? carrierType;

  /// Pagination
  final int page;

  const TruckFilter({
    this.search,
    this.features,
    this.brand,
    this.region,
    this.isVerified,
    this.loadCapacityGte,
    this.isAvailable,
    this.carrierType,
    this.page = 1,
  });

  /// Converts this filter into a map of query parameters,
  /// omitting any null/empty values.
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{'page': page, 'limit': 10, };

    // 'isVerified': true
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (features != null && features!.isNotEmpty) params['features'] = features;
    if (brand != null && brand!.isNotEmpty) params['brand'] = brand;
    if (region != null && region!.isNotEmpty) params['region'] = region;
    if (isVerified != null) params['isVerified'] = isVerified;
    if (loadCapacityGte != null) params['capacity_gte'] = loadCapacityGte;
    if (isAvailable != null) params['isAvailable'] = isAvailable;
    if (carrierType != null && carrierType!.isNotEmpty) {
      params['carrierType'] = carrierType;
    }

    return params;
  }

  bool get hasActiveFilters =>
      search != null ||
      features != null ||
      brand != null ||
      region != null ||
      isVerified != null ||
      loadCapacityGte != null ||
      isAvailable != null ||
      carrierType != null;

  TruckFilter copyWith({
    String? search,
    String? features,
    String? brand,
    String? region,
    bool? isVerified,
    double? loadCapacityGte,
    bool? isAvailable,
    String? carrierType,
    int? page,
    // Pass explicit null to clear a field
    bool clearSearch = false,
    bool clearFeature = false,
    bool clearBrand = false,
    bool clearRegion = false,
    bool clearIsVerified = false,
    bool clearLoadCapacity = false,
    bool clearIsAvailable = false,
    bool clearCarrierType = false,
  }) {
    return TruckFilter(
      search: clearSearch ? null : (search ?? this.search),
      features: clearFeature ? null : (features ?? this.features),
      brand: clearBrand ? null : (brand ?? this.brand),
      region: clearRegion ? null : (region ?? this.region),
      isVerified: clearIsVerified ? null : (isVerified ?? this.isVerified),
      loadCapacityGte: clearLoadCapacity
          ? null
          : (loadCapacityGte ?? this.loadCapacityGte),
      isAvailable: clearIsAvailable ? null : (isAvailable ?? this.isAvailable),
      carrierType: clearCarrierType ? null : (carrierType ?? this.carrierType),
      page: page ?? this.page,
    );
  }

  /// Returns a reset filter keeping only the page at 1.
  TruckFilter reset() => const TruckFilter();

  @override
  List<Object?> get props => [
    search,
    features,
    brand,
    region,
    isVerified,
    loadCapacityGte,
    isAvailable,
    carrierType,
    page,
  ];
}
