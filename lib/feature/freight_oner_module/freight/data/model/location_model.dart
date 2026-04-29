import 'package:json_annotation/json_annotation.dart';
part 'location_model.g.dart';

@JsonSerializable()
class LocationBaseResponse {
  final int? statusCode;
  final String? message;
  final List<RegionDto>? data;

  const LocationBaseResponse({this.statusCode, this.message, this.data});

  factory LocationBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationBaseResponseToJson(this);
}

@JsonSerializable()
class RegionDto {
  @JsonKey(name: '_id')
  final String? id;

  final String? region;
  final List<String>? city;

  const RegionDto({this.id, this.region, this.city});

  factory RegionDto.fromJson(Map<String, dynamic> json) =>
      _$RegionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionDtoToJson(this);
}
