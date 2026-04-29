import 'package:equatable/equatable.dart';

abstract class FeaturedCarrierEvent extends Equatable {
  const FeaturedCarrierEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeaturedCarriers extends FeaturedCarrierEvent {
  const LoadFeaturedCarriers();
}
