import '../app_config.dart';

class ProdConfig implements AppConfig {
  @override
  String get baseUrl => "https://backend-express-1-nocp.onrender.com/api/v1/";

  @override
  bool get enableLogs => false;

  @override
  bool get enableCrashlytics => true;
}