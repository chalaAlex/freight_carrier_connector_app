import 'package:clean_architecture/feature/landing/domain/entity/featured_carrier_entity.dart';
import 'package:equatable/equatable.dart';

abstract class FeaturedCarrierState extends Equatable {
  const FeaturedCarrierState();

  @override
  List<Object?> get props => [];
}

class FeaturedCarrierInitial extends FeaturedCarrierState {
  const FeaturedCarrierInitial();
}

class FeaturedCarrierLoading extends FeaturedCarrierState {
  const FeaturedCarrierLoading();
}

class FeaturedCarrierLoaded extends FeaturedCarrierState {
  final List<CarrierTruckEntity> carriers;

  const FeaturedCarrierLoaded(this.carriers);

  @override
  List<Object?> get props => [carriers];
}

class FeaturedCarrierError extends FeaturedCarrierState {
  final String message;

  const FeaturedCarrierError(this.message);

  @override
  List<Object?> get props => [message];
}
