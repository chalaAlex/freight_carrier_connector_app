import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('''
┌──────────────────────────────────────────────────────────────────────────────
│ 🌍 API REQUEST
├──────────────────────────────────────────────────────────────────────────────
│ METHOD: ${options.method}
│ URL: ${options.baseUrl}${options.path}
│ HEADERS: ${options.headers}
│ QUERY: ${options.queryParameters}
│ BODY: ${_pretty(options.data)}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('''
┌──────────────────────────────────────────────────────────────────────────────
│ ✅ API RESPONSE
├──────────────────────────────────────────────────────────────────────────────
│ STATUS: ${response.statusCode}
│ URL: ${response.requestOptions.path}
│ DATA: ${_pretty(response.data)}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('''
┌──────────────────────────────────────────────────────────────────────────────
│ ❌ API ERROR
├──────────────────────────────────────────────────────────────────────────────
│ TYPE: ${err.type}
│ STATUS: ${err.response?.statusCode}
│ URL: ${err.requestOptions.path}
│ MESSAGE: ${err.message}
│ DATA: ${_pretty(err.response?.data)}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(err);
  }

  String _pretty(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
