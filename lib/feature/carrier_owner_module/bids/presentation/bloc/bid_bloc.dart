import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/accept_bid_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/create_bid_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/get_bid_usecase.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/usecase/reject_bid_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bid_event.dart';
import 'bid_state.dart';

class BidBloc extends Bloc<BidEvent, BidState> {
  final CreateBidUseCase createBidUseCase;
  final GetBidUseCase getBidUseCase;
  final AcceptBidUseCase acceptBidUseCase;
  final RejectBidUseCase rejectBidUseCase;

  BidBloc({
    required this.createBidUseCase,
    required this.getBidUseCase,
    required this.acceptBidUseCase,
    required this.rejectBidUseCase,
  }) : super(BidInitial()) {
    on<SubmitBid>(_onSubmit);
    on<FetchBid>(_onFetchBid);
    on<AcceptBid>(_onAcceptBid);
    on<RejectBid>(_onRejectBid);
  }

  Future<void> _onSubmit(SubmitBid event, Emitter<BidState> emit) async {
    emit(BidLoading());
    final result = await createBidUseCase(
      CreateBidParams(
        freightId: event.freightId,
        carrierId: event.carrierId,
        bidAmount: event.bidAmount,
        message: event.message,
      ),
    );
    result.fold(
      (failure) => emit(BidError(failure.message)),
      (response) => emit(BidSuccess(response)),
    );
  }

  Future<void> _onFetchBid(FetchBid event, Emitter<BidState> emit) async {
    emit(BidLoading());
    final result = await getBidUseCase(event.bidId);
    result.fold(
      (failure) => emit(BidError(failure.message)),
      (response) => emit(
        BidDetailLoaded(
          response.bid ?? (throw Exception('Bid not found in response')),
        ),
      ),
    );
  }

  Future<void> _onAcceptBid(AcceptBid event, Emitter<BidState> emit) async {
    emit(BidActionLoading());
    final result = await acceptBidUseCase(event.bidId);
    await result.fold((failure) async => emit(BidError(failure.message)), (
      _,
    ) async {
      final refreshed = await getBidUseCase(event.bidId);
      refreshed.fold((failure) => emit(BidError(failure.message)), (response) {
        if (response.bid != null) {
          emit(
            BidActionSuccess(
              message: 'Bid accepted successfully',
              bid: response.bid!,
            ),
          );
        }
      });
    });
  }

  Future<void> _onRejectBid(RejectBid event, Emitter<BidState> emit) async {
    emit(BidActionLoading());
    final result = await rejectBidUseCase(event.bidId);
    await result.fold((failure) async => emit(BidError(failure.message)), (
      _,
    ) async {
      final refreshed = await getBidUseCase(event.bidId);
      refreshed.fold((failure) => emit(BidError(failure.message)), (response) {
        if (response.bid != null) {
          emit(
            BidActionSuccess(
              message: 'Bid rejected successfully',
              bid: response.bid!,
            ),
          );
        }
      });
    });
  }
}
