import 'package:clean_architecture/core/error/failure.dart';
import 'package:dio/dio.dart';

enum DataSource {
  success,
  badRequest,
  noContent,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeOut,
  cancel,
  sendTimeOut,
  cacheError,
  noInternetConnection,
  defaultErr,
  recieveTimeOut,
}

class ErrorHandler implements Exception {
  ErrorHandler.handle(dynamic error) {
    (error);
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = DataSource.defaultErr.getFailure();
    }
  }

  late Failure failure;

  Failure _handleError(DioException error) {
    (error);
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeOut.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeOut.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.recieveTimeOut.getFailure();
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case ResponseCode.badRequest:
            return DataSource.badRequest.getFailure();
          case ResponseCode.unauthorized:
            return DataSource.unauthorized.getFailure();
          case ResponseCode.notFound:
            return DataSource.notFound.getFailure();
          case ResponseCode.forbidden:
            return DataSource.forbidden.getFailure();
          case ResponseCode.internalServerError:
            return DataSource.internalServerError.getFailure();
          default:
            return DataSource.defaultErr.getFailure();
        }
      default:
        return DataSource.defaultErr.getFailure();
    }
  }
}

class ResponseCode {
  static const int badRequest = 400;
  static const int cacheError = -6;
  static const int cancel = -3;
  static const int connectTimeOut = -2;
  static const int defaultErr = -1;
  static const int forbidden = 403;
  static const int internalServerError = 500;
  static const int notFound = 404;
  static const int noContent = 204;
  static const int noInternetConnection = -7;
  static const int recieveTimeOut = -4;
  static const int sendTimeOut = -5;
  static const int success = 200;
  static const int unauthorized = 401;
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequest);
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden);
      case DataSource.unauthorized:
        return Failure(ResponseCode.unauthorized, ResponseMessage.unauthorized);
      case DataSource.internalServerError:
        return Failure(
          ResponseCode.internalServerError,
          ResponseMessage.internalServerError,
        );
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound);
      case DataSource.defaultErr:
        return Failure(ResponseCode.defaultErr, ResponseMessage.defaultErr);
      case DataSource.connectTimeOut:
        return Failure(
          ResponseCode.connectTimeOut,
          ResponseMessage.connectTimeOut,
        );
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case DataSource.recieveTimeOut:
        return Failure(
          ResponseCode.recieveTimeOut,
          ResponseMessage.recieveTimeOut,
        );
      case DataSource.sendTimeOut:
        return Failure(ResponseCode.sendTimeOut, ResponseMessage.sendTimeOut);
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(
          ResponseCode.noInternetConnection,
          ResponseMessage.noInternetConnection,
        );
      default:
        return Failure(ResponseCode.defaultErr, ResponseMessage.defaultErr);
    }
  }
}

class ResponseMessage {
  static const String badRequest = 'bad request, try again later';
  static const String cacheError = 'cache error, try again';
  static const String cancel = 'request cancelled';
  static const String connectTimeOut = ' timeout , try again later';
  static const String defaultErr = 'some thing wrong, try again later';
  static const String forbidden = 'forbidden, try again later';
  static const String internalServerError = 'Internal Server Error';
  static const String notFound = 'requested item not found';
  static const String noContent = 'no content';
  static const String noInternetConnection = 'Please check your Internet Connection';
  static const String recieveTimeOut = ' timeout , try again later';
  static const String sendTimeOut = ' timeout , try again later';
  static const String success = 'success';
  static const String unauthorized = 'unauthorized';
}

class ApiInternalStatus {
  static const bool failure = false;
  static const bool success = true;
}
