import 'package:equatable/equatable.dart';

abstract class TruckEvent extends Equatable {
  const TruckEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialTrucks extends TruckEvent {}

class RefreshTrucks extends TruckEvent {}

class FetchNextPage extends TruckEvent {}
