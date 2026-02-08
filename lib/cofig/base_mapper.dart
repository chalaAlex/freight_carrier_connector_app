abstract class BaseMapper<DTO, ENTITY> {
  ENTITY mapToEntity(DTO dto);
}

extension NullableMapper<DTO, ENTITY> on BaseMapper<DTO, ENTITY> {
  ENTITY? mapNullable(DTO? dto) {
    if (dto == null) return null;
    return mapToEntity(dto);
  }
}