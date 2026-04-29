import 'package:equatable/equatable.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object?> get props => [];
}

class FavouriteInitial extends FavouriteState {
  final bool isFavourite;
  const FavouriteInitial({this.isFavourite = false});

  @override
  List<Object?> get props => [isFavourite];
}

class FavouriteLoading extends FavouriteState {}

class FavouriteSuccess extends FavouriteState {
  final bool isFavourite;
  const FavouriteSuccess({required this.isFavourite});

  @override
  List<Object?> get props => [isFavourite];
}

class FavouriteError extends FavouriteState {
  final String message;
  const FavouriteError(this.message);

  @override
  List<Object?> get props => [message];
}
