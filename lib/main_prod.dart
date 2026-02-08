import 'package:clean_architecture/cofig/env/env.dart';
import 'package:clean_architecture/cofig/env/env_config.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/main_dev.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.init(Environment.prod);
  await init(Environment.prod);
  runApp(const MyApp());
}
