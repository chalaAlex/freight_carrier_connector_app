import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}
class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  const WalletLoaded(this.wallet);
  @override
  List<Object?> get props => [wallet];
}

class WalletTransactionsLoaded extends WalletState {
  final WalletTransactionsResponseEntity data;
  const WalletTransactionsLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class WithdrawalRequested extends WalletState {}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
  @override
  List<Object?> get props => [message];
}
