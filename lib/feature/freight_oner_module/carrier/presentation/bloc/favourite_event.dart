import 'package:equatable/equatable.dart';

abstract class FavouriteEvent extends Equatable {
  const FavouriteEvent();

  @override
  List<Object?> get props => [];
}

class MakeFavourite extends FavouriteEvent {
  final String carrierId;
  const MakeFavourite(this.carrierId);

  @override
  List<Object?> get props => [carrierId];
}

class DisableFavourite extends FavouriteEvent {
  final String carrierId;
  const DisableFavourite(this.carrierId);

  @override
  List<Object?> get props => [carrierId];
}
