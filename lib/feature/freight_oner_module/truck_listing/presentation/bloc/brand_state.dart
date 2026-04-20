import 'package:equatable/equatable.dart';
import '../../domain/entities/brand_entity.dart';

abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object?> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandSuccess extends BrandState {
  final BrandBaseResponseEntity brands;

  const BrandSuccess(this.brands);

  @override
  List<Object?> get props => [brands];
}

class BrandError extends BrandState {
  final String message;

  const BrandError(this.message);

  @override
  List<Object?> get props => [message];
}
