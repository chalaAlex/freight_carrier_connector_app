import 'package:clean_architecture/cofig/env/env_config/dev_config.dart';
import 'package:clean_architecture/core/token/auth_interceptor.dart';
import 'package:clean_architecture/core/token/toke_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_logger.dart';

class DioFactory {
  static Dio createDio(TokenLocalDataSource tokenLocalDataSource) {
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

    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      AuthInterceptor(tokenLocalDataSource),
    ]);

    if (kDebugMode) {
      dio.interceptors.add(DioLoggerInterceptor());
    }
    return dio;
  }
}
