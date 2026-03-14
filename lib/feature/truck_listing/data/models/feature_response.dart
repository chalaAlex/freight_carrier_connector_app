import 'package:json_annotation/json_annotation.dart';
part 'feature_response.g.dart';

@JsonSerializable()
class FeatureBaseResponse {
  final int? statusCode;
  final String? message;
  final int? total;
  final FeatureData? data;

  FeatureBaseResponse({this.statusCode, this.message, this.total, this.data});

  factory FeatureBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$FeatureBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureBaseResponseToJson(this);
}

@JsonSerializable()
class FeatureData {
  final List<Feature>? features;

  FeatureData({this.features});

  factory FeatureData.fromJson(Map<String, dynamic> json) =>
      _$FeatureDataFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureDataToJson(this);
}

@JsonSerializable()
class Feature {
  @JsonKey(name: "_id")
  final String? id;

  final String? name;
  final String? icon;
  final String? description;
  final bool? isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Feature({
    this.id,
    this.name,
    this.icon,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureToJson(this);
}
