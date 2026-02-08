// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..message = json['message'] as String?
  ..statusCode = (json['statusCode'] as num?)?.toInt();

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
    };

SignUpModel _$SignUpModelFromJson(Map<String, dynamic> json) =>
    SignUpModel(
        data: json['data'] == null
            ? null
            : SignUpData.fromJson(json['data'] as Map<String, dynamic>),
      )
      ..message = json['message'] as String?
      ..statusCode = (json['statusCode'] as num?)?.toInt();

Map<String, dynamic> _$SignUpModelToJson(SignUpModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

SignUpData _$SignUpDataFromJson(Map<String, dynamic> json) => SignUpData(
  user: json['user'] == null
      ? null
      : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SignUpDataToJson(SignUpData instance) =>
    <String, dynamic>{'user': instance.user};

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: json['_id'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  role: json['role'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'createdAt': instance.createdAt,
    };
