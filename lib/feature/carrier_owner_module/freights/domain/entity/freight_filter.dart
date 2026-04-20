import 'package:equatable/equatable.dart';

class FreightFilter extends Equatable {
  // Multi-select fields
  final List<String>? cargoTypes; // cargo.type
  final List<String>? truckTypes; // truckRequirement.type
  final List<String>? pricingTypes; // pricing.type
  final List<String>? statuses; // status

  // Single-value route fields
  final String? pickupRegion;
  final String? pickupCity;
  final String? dropoffRegion;
  final String? dropoffCity;

  const FreightFilter({
    this.cargoTypes,
    this.truckTypes,
    this.pricingTypes,
    this.statuses,
    this.pickupRegion,
    this.pickupCity,
    this.dropoffRegion,
    this.dropoffCity,
  });

  bool get isEmpty =>
      (cargoTypes == null || cargoTypes!.isEmpty) &&
      (truckTypes == null || truckTypes!.isEmpty) &&
      (pricingTypes == null || pricingTypes!.isEmpty) &&
      (statuses == null || statuses!.isEmpty) &&
      pickupRegion == null &&
      pickupCity == null &&
      dropoffRegion == null &&
      dropoffCity == null;

  FreightFilter copyWith({
    List<String>? cargoTypes,
    List<String>? truckTypes,
    List<String>? pricingTypes,
    List<String>? statuses,
    String? pickupRegion,
    String? pickupCity,
    String? dropoffRegion,
    String? dropoffCity,
  }) {
    return FreightFilter(
      cargoTypes: cargoTypes ?? this.cargoTypes,
      truckTypes: truckTypes ?? this.truckTypes,
      pricingTypes: pricingTypes ?? this.pricingTypes,
      statuses: statuses ?? this.statuses,
      pickupRegion: pickupRegion ?? this.pickupRegion,
      pickupCity: pickupCity ?? this.pickupCity,
      dropoffRegion: dropoffRegion ?? this.dropoffRegion,
      dropoffCity: dropoffCity ?? this.dropoffCity,
    );
  }

  @override
  List<Object?> get props => [
    cargoTypes,
    truckTypes,
    pricingTypes,
    statuses,
    pickupRegion,
    pickupCity,
    dropoffRegion,
    dropoffCity,
  ];
}
