import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/signup/domain/entities/sign_up_entity.dart';
import 'package:clean_architecture/feature/signup/domain/usecases/sign_up_usecase.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUsecase _signUpUsecase;

  SignUpBloc(this._signUpUsecase) : super(const SignUpState()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    /// 1️⃣ Move to loading state
    emit(state.copyWith(status: SignUpStatus.loading, errorMessage: null));

    final result = await _signUpUsecase(
      SignUpUseCaseInput(
        event.firstName,
        event.lastName,
        event.email,
        event.phone,
        event.password,
        event.confirmPassword,
        event.role,
      ),
    );

    /// 2️⃣ Handle Either result
    result.fold(
      (Failure failure) => emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (SignUpBaseResponseEntity user) => emit(
        state.copyWith(
          status: SignUpStatus.success,
          user: user,
        ),
      ),
    );
  }
}
