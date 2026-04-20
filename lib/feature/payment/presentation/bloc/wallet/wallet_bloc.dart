import 'package:clean_architecture/feature/payment/domain/usecase/get_wallet_transactions_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/get_wallet_usecase.dart';
import 'package:clean_architecture/feature/payment/domain/usecase/request_withdrawal_usecase.dart';
import 'package:clean_architecture/cofig/base_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase getWalletUseCase;
  final GetWalletTransactionsUseCase getWalletTransactionsUseCase;
  final RequestWithdrawalUseCase requestWithdrawalUseCase;

  WalletBloc({
    required this.getWalletUseCase,
    required this.getWalletTransactionsUseCase,
    required this.requestWithdrawalUseCase,
  }) : super(WalletInitial()) {
    on<GetWalletEvent>(_onGetWallet);
    on<GetWalletTransactionsEvent>(_onGetTransactions);
    on<RequestWithdrawalEvent>(_onRequestWithdrawal);
  }

  Future<void> _onGetWallet(GetWalletEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await getWalletUseCase(NoParams());
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> _onGetTransactions(GetWalletTransactionsEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await getWalletTransactionsUseCase(
      GetWalletTransactionsParams(page: event.page, limit: event.limit),
    );
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (data) => emit(WalletTransactionsLoaded(data)),
    );
  }

  Future<void> _onRequestWithdrawal(RequestWithdrawalEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await requestWithdrawalUseCase(event.amount);
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (_) => emit(WithdrawalRequested()),
    );
  }
}
