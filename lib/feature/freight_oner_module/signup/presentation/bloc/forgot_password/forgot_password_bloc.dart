import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';
import '../../../domain/usecases/forgot_password_usecase.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordBloc({required this.forgotPasswordUseCase})
    : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await forgotPasswordUseCase(event.email);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(state.copyWith(status: ForgotPasswordStatus.success)),
    );
  }
}
