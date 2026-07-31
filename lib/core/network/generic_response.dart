import 'package:json_annotation/json_annotation.dart';

part 'generic_response.g.dart';

/// Generic response model for simple API responses
@JsonSerializable()
class GenericResponse {
  final String? status;
  final String? message;
  final String? token;

  GenericResponse({this.status, this.message, this.token});

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenericResponseToJson(this);
}
