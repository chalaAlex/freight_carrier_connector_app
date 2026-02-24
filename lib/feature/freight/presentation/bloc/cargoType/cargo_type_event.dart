import 'package:equatable/equatable.dart';

abstract class CargoTypeEvent extends Equatable {
  const CargoTypeEvent();

  @override
  List<Object?> get props => [];
}

class FetchCargoTypesEvent extends CargoTypeEvent {
  const FetchCargoTypesEvent();
}
