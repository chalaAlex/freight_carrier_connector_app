import 'package:equatable/equatable.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/domain/entities/login_entity.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final LoginBaseResponseEntity? user;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    LoginBaseResponseEntity? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
