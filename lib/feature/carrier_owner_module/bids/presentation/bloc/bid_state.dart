import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/get_bid_entity.dart';
import 'package:equatable/equatable.dart';

abstract class BidState extends Equatable {
  const BidState();
  @override
  List<Object?> get props => [];
}

class BidInitial extends BidState {}

class BidLoading extends BidState {}

class BidSuccess extends BidState {
  final CreateBidResponseEntity response;
  const BidSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class BidDetailLoaded extends BidState {
  final GetBidDetailEntity bid;
  const BidDetailLoaded(this.bid);
  @override
  List<Object?> get props => [bid];
}

class BidActionSuccess extends BidState {
  final String message;
  final GetBidDetailEntity bid; // updated bid with new status
  const BidActionSuccess({required this.message, required this.bid});
  @override
  List<Object?> get props => [message, bid];
}

class BidActionLoading extends BidState {}

class BidError extends BidState {
  final String message;
  const BidError(this.message);
  @override
  List<Object?> get props => [message];
}
