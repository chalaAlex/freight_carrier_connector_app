import 'package:json_annotation/json_annotation.dart';
part 'sign_up_model.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'statusCode')
  int? statusCode;
}

@JsonSerializable()
class SignUpModel extends BaseResponse {
  @JsonKey(name: 'data')
  SignUpData? data;

  SignUpModel({this.data});

  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}

@JsonSerializable()
class SignUpData {
  @JsonKey(name: 'user')
  UserResponse? user;

  SignUpData({this.user});

  factory SignUpData.fromJson(Map<String, dynamic> json) =>
      _$SignUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpDataToJson(this);
}

@JsonSerializable()
@JsonSerializable()
class UserResponse {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'firstName')
  String? firstName;

  @JsonKey(name: 'lastName')
  String? lastName;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'role')
  String? role;

  @JsonKey(name: 'createdAt')
  String? createdAt;

  UserResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
