import 'package:equatable/equatable.dart';

class LoginBaseResponseEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final String? token;
  final LoginDataEntity? data;

  const LoginBaseResponseEntity({this.statusCode, this.message, this.token, this.data});

  @override
  List<Object?> get props => [statusCode, message, token, data];
}

class LoginDataEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? role;
  final DateTime? createdAt;

  const LoginDataEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    role,
    createdAt,
  ];
}
