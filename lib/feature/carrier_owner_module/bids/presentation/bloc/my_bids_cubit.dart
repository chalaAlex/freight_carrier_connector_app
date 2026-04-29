import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/my_bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/get_my_bids_usecase.dart';

// ─── State ────────────────────────────────────────────────────────────────────

abstract class MyBidsState extends Equatable {
  const MyBidsState();
  @override
  List<Object?> get props => [];
}

class MyBidsInitial extends MyBidsState {}

class MyBidsLoading extends MyBidsState {}

class MyBidsLoaded extends MyBidsState {
  final List<MyBidEntity> bids;
  const MyBidsLoaded(this.bids);
  @override
  List<Object?> get props => [bids];
}

class MyBidsError extends MyBidsState {
  final String message;
  const MyBidsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class MyBidsCubit extends Cubit<MyBidsState> {
  final GetMyBidsUseCase getMyBidsUseCase;

  MyBidsCubit({required this.getMyBidsUseCase}) : super(MyBidsInitial());

  Future<void> load() async {
    emit(MyBidsLoading());
    final result = await getMyBidsUseCase();
    result.fold(
      (failure) => emit(MyBidsError(failure.message)),
      (bids) => emit(MyBidsLoaded(bids)),
    );
  }
}
