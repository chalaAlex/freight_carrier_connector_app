import 'package:clean_architecture/cofig/env/env_config/dev_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_logger.dart';

class DioFactory {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: DevConfig().baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(DioLoggerInterceptor());
    }
    return dio;
  }
}
