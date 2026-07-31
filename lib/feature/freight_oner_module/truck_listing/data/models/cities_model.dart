import 'package:json_annotation/json_annotation.dart';
import '../../../../../cofig/base_mapper.dart';
import '../../domain/entities/cities_entity.dart';

part 'cities_model.g.dart';

@JsonSerializable()
class CitiesBaseResponse {
  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'statusCode')
  int? statusCode;

  @JsonKey(name: 'total')
  int? total;

  @JsonKey(name: 'data')
  CitiesDataModel? data;

  CitiesBaseResponse({this.message, this.statusCode, this.data, this.total});

  factory CitiesBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$CitiesBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CitiesBaseResponseToJson(this);
}

@JsonSerializable()
class CityDto {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'region')
  final RegionRef? region;

  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const CityDto({
    required this.id,
    required this.name,
    this.region,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CityDto.fromJson(Map<String, dynamic> json) =>
      _$CityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CityDtoToJson(this);
}

@JsonSerializable()
class RegionRef {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  const RegionRef({this.id, this.name});

  factory RegionRef.fromJson(Map<String, dynamic> json) =>
      _$RegionRefFromJson(json);

  Map<String, dynamic> toJson() => _$RegionRefToJson(this);
}

@JsonSerializable()
class CitiesDataModel {
  @JsonKey(name: 'cities')
  final List<CityDto>? cities;

  CitiesDataModel({this.cities});

  factory CitiesDataModel.fromJson(Map<String, dynamic> json) =>
      _$CitiesDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CitiesDataModelToJson(this);
}

// Mapper
class CityMapper extends BaseMapper<CityDto, CityEntity> {
  @override
  CityEntity mapToEntity(CityDto dto) {
    return CityEntity(
      id: dto.id,
      name: dto.name,
      regionId: dto.region?.id,
      regionName: dto.region?.name,
      isActive: dto.isActive,
      createdAt: dto.createdAt != null
          ? DateTime.tryParse(dto.createdAt!)
          : null,
      updatedAt: dto.updatedAt != null
          ? DateTime.tryParse(dto.updatedAt!)
          : null,
    );
  }
}

class CitiesBaseResponseMapper
    extends BaseMapper<CitiesBaseResponse, CitiesBaseResponseEntity> {
  final CityMapper _cityMapper = CityMapper();

  @override
  CitiesBaseResponseEntity mapToEntity(CitiesBaseResponse dto) {
    return CitiesBaseResponseEntity(
      statusCode: dto.statusCode,
      message: dto.message,
      total: dto.total,
      cities: dto.data?.cities
          ?.map((city) => _cityMapper.mapToEntity(city))
          .toList(),
    );
  }
}
