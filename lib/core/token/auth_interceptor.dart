import 'package:clean_architecture/core/token/toke_local_data_source.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final TokenLocalDataSource tokenLocalDataSource;

  AuthInterceptor(this.tokenLocalDataSource);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenLocalDataSource.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
