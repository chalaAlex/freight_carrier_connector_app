import 'environment.dart';
import 'env_config/dev_config.dart';
import 'env_config/stage_config.dart';
import 'env_config/prod_config.dart';
import 'app_config.dart';

class EnvConfig {
  static late AppConfig config;

  static void init(Environment env) {
    switch (env) {
      case Environment.dev:
        config = DevConfig();
        break;
      case Environment.stage:
        config = StageConfig();
        break;
      case Environment.prod:
        config = ProdConfig();
        break;
      default:
        config = DevConfig();
    }
  }
}
