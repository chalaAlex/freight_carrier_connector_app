import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class GetWalletEvent extends WalletEvent {}

class GetWalletTransactionsEvent extends WalletEvent {
  final int page;
  final int limit;
  const GetWalletTransactionsEvent({this.page = 1, this.limit = 20});
  @override
  List<Object?> get props => [page, limit];
}

class RequestWithdrawalEvent extends WalletEvent {
  final double amount;
  const RequestWithdrawalEvent(this.amount);
  @override
  List<Object?> get props => [amount];
}
