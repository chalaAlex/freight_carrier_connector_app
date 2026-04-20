import 'package:json_annotation/json_annotation.dart';

part 'brand_response.g.dart';

@JsonSerializable()
class BrandBaseResponse {
  final int? statusCode;
  final String? message;
  final int? total;
  final BrandData? data;

  BrandBaseResponse({this.statusCode, this.message, this.total, this.data});

  factory BrandBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BrandBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BrandBaseResponseToJson(this);
}

@JsonSerializable()
class BrandData {
  final List<Brand>? brands;

  BrandData({this.brands});

  factory BrandData.fromJson(Map<String, dynamic> json) =>
      _$BrandDataFromJson(json);

  Map<String, dynamic> toJson() => _$BrandDataToJson(this);
}

@JsonSerializable()
class Brand {
  @JsonKey(name: "_id")
  final String? id;

  final String? name;
  final String? description;
  final bool? isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Brand({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}