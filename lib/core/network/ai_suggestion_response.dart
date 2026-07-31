import 'package:json_annotation/json_annotation.dart';
part 'ai_suggestion_response.g.dart';

@JsonSerializable()
class AiSuggestionResponse {
  final String status;
  final AiSuggestionData data;

  const AiSuggestionResponse({required this.status, required this.data});

  factory AiSuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$AiSuggestionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AiSuggestionResponseToJson(this);
}

@JsonSerializable()
class AiSuggestionData {
  final String suggestion;

  const AiSuggestionData({required this.suggestion});

  factory AiSuggestionData.fromJson(Map<String, dynamic> json) =>
      _$AiSuggestionDataFromJson(json);
  Map<String, dynamic> toJson() => _$AiSuggestionDataToJson(this);
}
