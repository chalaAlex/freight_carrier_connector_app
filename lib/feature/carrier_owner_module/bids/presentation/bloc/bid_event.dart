import 'package:equatable/equatable.dart';

abstract class BidEvent extends Equatable {
  const BidEvent();
  @override
  List<Object?> get props => [];
}

class SubmitBid extends BidEvent {
  final String freightId;
  final String carrierId;
  final double bidAmount;
  final String message;

  const SubmitBid({
    required this.freightId,
    required this.carrierId,
    required this.bidAmount,
    required this.message,
  });

  @override
  List<Object?> get props => [freightId, carrierId, bidAmount, message];
}

class FetchBid extends BidEvent {
  final String bidId;
  const FetchBid(this.bidId);
  @override
  List<Object?> get props => [bidId];
}

class AcceptBid extends BidEvent {
  final String bidId;
  const AcceptBid(this.bidId);
  @override
  List<Object?> get props => [bidId];
}

class RejectBid extends BidEvent {
  final String bidId;
  const RejectBid(this.bidId);
  @override
  List<Object?> get props => [bidId];
}
