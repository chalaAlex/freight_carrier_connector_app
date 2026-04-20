import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/feature/freight_oner_module/carrier/domain/usecase/toggle_favourite_usecase.dart';
import 'favourite_event.dart';
import 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final MakeCarrierFavouriteUseCase makeCarrierFavouriteUseCase;
  final DisableFavouriteUseCase disableFavouriteUseCase;

  FavouriteBloc({
    required this.makeCarrierFavouriteUseCase,
    required this.disableFavouriteUseCase,
  }) : super(const FavouriteInitial()) {
    on<MakeFavourite>(_onMakeFavourite);
    on<DisableFavourite>(_onDisableFavourite);
  }

  Future<void> _onMakeFavourite(
    MakeFavourite event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(FavouriteLoading());
    final result = await makeCarrierFavouriteUseCase(event.carrierId);
    result.fold(
      (failure) => emit(FavouriteError(failure.message)),
      (_) => emit(const FavouriteSuccess(isFavourite: true)),
    );
  }

  Future<void> _onDisableFavourite(
    DisableFavourite event,
    Emitter<FavouriteState> emit,
  ) async {
    emit(FavouriteLoading());
    final result = await disableFavouriteUseCase(event.carrierId);
    result.fold(
      (failure) => emit(FavouriteError(failure.message)),
      (_) => emit(const FavouriteSuccess(isFavourite: false)),
    );
  }
}
