import 'package:json_annotation/json_annotation.dart';
import '../../../../../cofig/base_mapper.dart';
import '../../domain/entities/regions_entity.dart';

part 'regions_model.g.dart';

@JsonSerializable()
class RegionsBaseResponse {
  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'statusCode')
  int? statusCode;

  @JsonKey(name: 'total')
  int? total;

  @JsonKey(name: 'data')
  RegionsDataModel? data;

  RegionsBaseResponse({this.message, this.statusCode, this.data, this.total});

  factory RegionsBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$RegionsBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegionsBaseResponseToJson(this);
}

@JsonSerializable()
class RegionDto {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const RegionDto({
    required this.id,
    required this.name,
    required this.country,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory RegionDto.fromJson(Map<String, dynamic> json) =>
      _$RegionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionDtoToJson(this);
}

@JsonSerializable()
class RegionsDataModel {
  @JsonKey(name: 'regions')
  final List<RegionDto>? regions;

  RegionsDataModel({this.regions});

  factory RegionsDataModel.fromJson(Map<String, dynamic> json) =>
      _$RegionsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionsDataModelToJson(this);
}

// Mapper
class RegionMapper extends BaseMapper<RegionDto, RegionEntity> {
  @override
  RegionEntity mapToEntity(RegionDto dto) {
    return RegionEntity(
      id: dto.id,
      name: dto.name,
      country: dto.country,
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

class RegionsBaseResponseMapper
    extends BaseMapper<RegionsBaseResponse, RegionsBaseResponseEntity> {
  final RegionMapper _regionMapper = RegionMapper();

  @override
  RegionsBaseResponseEntity mapToEntity(RegionsBaseResponse dto) {
    return RegionsBaseResponseEntity(
      statusCode: dto.statusCode,
      message: dto.message,
      total: dto.total,
      regions: dto.data?.regions
          ?.map((region) => _regionMapper.mapToEntity(region))
          .toList(),
    );
  }
}
