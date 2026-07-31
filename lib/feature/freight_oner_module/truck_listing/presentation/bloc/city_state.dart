import 'package:equatable/equatable.dart';
import '../../domain/entities/cities_entity.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CitySuccess extends CityState {
  final CitiesBaseResponseEntity cities;

  const CitySuccess(this.cities);

  @override
  List<Object?> get props => [cities];
}

class CityError extends CityState {
  final String message;

  const CityError(this.message);

  @override
  List<Object?> get props => [message];
}
