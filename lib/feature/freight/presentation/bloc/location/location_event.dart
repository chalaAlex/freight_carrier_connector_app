import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all regions
class FetchRegionsEvent extends LocationEvent {
  const FetchRegionsEvent();
}

/// Event to fetch cities for a specific region
class FetchCitiesEvent extends LocationEvent {
  final String region;

  const FetchCitiesEvent(this.region);

  @override
  List<Object?> get props => [region];
}
