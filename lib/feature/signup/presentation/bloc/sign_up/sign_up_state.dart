import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/signup/domain/entities/sign_up_entity.dart';

/// Represents the current lifecycle stage of the signup process
enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  /// Current status of the request
  final SignUpStatus status;

  /// Response entity when signup succeeds
  final SignUpBaseResponseEntity? user;

  /// Error message when signup fails
  final String? errorMessage;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// Immutable state update mechanism
  SignUpState copyWith({
    SignUpStatus? status,
    SignUpBaseResponseEntity? user,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
