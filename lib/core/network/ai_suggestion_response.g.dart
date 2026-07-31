// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_suggestion_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiSuggestionResponse _$AiSuggestionResponseFromJson(
  Map<String, dynamic> json,
) => AiSuggestionResponse(
  status: json['status'] as String,
  data: AiSuggestionData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AiSuggestionResponseToJson(
  AiSuggestionResponse instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

AiSuggestionData _$AiSuggestionDataFromJson(Map<String, dynamic> json) =>
    AiSuggestionData(suggestion: json['suggestion'] as String);

Map<String, dynamic> _$AiSuggestionDataToJson(AiSuggestionData instance) =>
    <String, dynamic>{'suggestion': instance.suggestion};
