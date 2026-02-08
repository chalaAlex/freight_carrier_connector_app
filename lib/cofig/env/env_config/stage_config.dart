import '../app_config.dart';

class StageConfig implements AppConfig {
  @override
  String get baseUrl => "https://stage-api.yourapp.com";

  @override
  bool get enableLogs => true;

  @override
  bool get enableCrashlytics => true;
}
