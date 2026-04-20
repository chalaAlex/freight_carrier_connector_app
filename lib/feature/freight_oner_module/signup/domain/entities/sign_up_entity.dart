import 'package:equatable/equatable.dart';

class SignUpBaseResponseEntity extends Equatable {
  final String? message;
  final int? statusCode;
  final SignUpDataModel? data;

  const SignUpBaseResponseEntity({this.message, this.statusCode, this.data});

  @override
  List<Object?> get props => [message, statusCode, data];
}

class SignUpDataModel extends Equatable {
  final UserModel? user;

  const SignUpDataModel({this.user});

  @override
  List<Object?> get props => [user];
}

class UserModel extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? role;
  final DateTime? createdAt;

  const UserModel({
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
