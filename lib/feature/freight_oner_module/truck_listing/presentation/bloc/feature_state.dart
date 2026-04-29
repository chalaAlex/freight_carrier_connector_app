import 'package:equatable/equatable.dart';
import '../../domain/entities/feature_entity.dart';

abstract class FeatureState extends Equatable {
  const FeatureState();

  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}

class FeatureLoading extends FeatureState {}

class FeatureSuccess extends FeatureState {
  final FeatureBaseResponseEntity features;

  const FeatureSuccess(this.features);

  @override
  List<Object?> get props => [features];
}

class FeatureError extends FeatureState {
  final String message;

  const FeatureError(this.message);

  @override
  List<Object?> get props => [message];
}
