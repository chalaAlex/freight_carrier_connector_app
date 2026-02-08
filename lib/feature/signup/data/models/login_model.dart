import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';

@JsonSerializable()
class LoginBaseResponse {
  @JsonKey(name: 'statusCode')
  int? statusCode;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'token')
  String? token;

  @JsonKey(name: 'data')
  LoginDataModel? data;



  LoginBaseResponse({this.statusCode, this.token, this.message, this.data});

  factory LoginBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginBaseResponseToJson(this);
}

@JsonSerializable()
class UserDto {
  @JsonKey(name: '_id')
  final String? id;

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? role;
  final String? createdAt;

  UserDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}



@JsonSerializable()
class LoginDataModel {
  final UserDto? user;

  LoginDataModel({this.user});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);
}