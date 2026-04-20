import 'package:clean_architecture/feature/carrier_owner_module/freights/domain/entity/freight_filter.dart';
import 'package:equatable/equatable.dart';

abstract class FreightListingEvent extends Equatable {
  const FreightListingEvent();

  @override
  List<Object?> get props => [];
}

class FetchFreightListing extends FreightListingEvent {
  final FreightFilter? filter;

  const FetchFreightListing({this.filter});

  @override
  List<Object?> get props => [filter];
}

class ApplyFreightFilter extends FreightListingEvent {
  final FreightFilter filter;

  const ApplyFreightFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ClearFreightFilter extends FreightListingEvent {
  const ClearFreightFilter();
}

class LoadMoreFreights extends FreightListingEvent {
  const LoadMoreFreights();
}

class RefreshFreightListing extends FreightListingEvent {
  const RefreshFreightListing();
}
