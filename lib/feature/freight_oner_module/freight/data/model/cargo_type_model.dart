import 'package:json_annotation/json_annotation.dart';
part 'cargo_type_model.g.dart';

@JsonSerializable()
class CargoTypeBaseResponse {
  @JsonKey(name: 'statusCode')
  final int? statusCode;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'total')
  final int? total;

  @JsonKey(name: 'data')
  final List<CargoTypeDto>? data;

  const CargoTypeBaseResponse({
    this.statusCode,
    this.message,
    this.total,
    this.data,
  });

  factory CargoTypeBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$CargoTypeBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CargoTypeBaseResponseToJson(this);
}

@JsonSerializable()
class CargoTypeDto {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'cargoType')
  final String? cargoType;

  const CargoTypeDto({this.id, this.cargoType});

  factory CargoTypeDto.fromJson(Map<String, dynamic> json) =>
      _$CargoTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CargoTypeDtoToJson(this);
}
