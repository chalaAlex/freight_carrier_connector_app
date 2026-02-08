import '../app_config.dart';

class DevConfig implements AppConfig {
  @override
  String get baseUrl => "http://10.0.2.2:8000/api/v1";

  @override
  bool get enableLogs => true;

  @override
  bool get enableCrashlytics => false;
}
