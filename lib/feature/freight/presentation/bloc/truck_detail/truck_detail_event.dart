import 'package:equatable/equatable.dart';

abstract class TruckDetailEvent extends Equatable {
  const TruckDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTruckDetailEvent extends TruckDetailEvent {
  final String truckId;

  const FetchTruckDetailEvent(this.truckId);

  @override
  List<Object?> get props => [truckId];
}

class ResetTruckDetailEvent extends TruckDetailEvent {
  const ResetTruckDetailEvent();
}
