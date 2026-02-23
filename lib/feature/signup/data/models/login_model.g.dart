// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginBaseResponse _$LoginBaseResponseFromJson(Map<String, dynamic> json) =>
    LoginBaseResponse(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      token: json['token'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LoginDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginBaseResponseToJson(LoginBaseResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'token': instance.token,
      'data': instance.data,
    };

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['_id'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  role: json['role'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'createdAt': instance.createdAt,
};

LoginDataModel _$LoginDataModelFromJson(Map<String, dynamic> json) =>
    LoginDataModel(
      user: json['user'] == null
          ? null
          : UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginDataModelToJson(LoginDataModel instance) =>
    <String, dynamic>{'user': instance.user};
