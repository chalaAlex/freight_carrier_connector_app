import 'package:clean_architecture/core/error/failure.dart';
import 'package:dio/dio.dart';

enum DataSource {
  SUCCESS,
  BAD_REQUEST,
  NO_CONTENT,
  FORBIDDEN,
  UNAUTHORIZED,
  NOTFOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
  RECEIVE_TIMEOUT,
}

class ErrorHandler implements Exception {
  ErrorHandler.handle(dynamic error) {
    (error);
    if (error is DioException) {
      // Dio error so it's an error from the response of the API

      failure = _handleError(error);
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  late Failure failure;

  Failure _handleError(DioException error) {
    (error);
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECEIVE_TIMEOUT.getFailure();
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case ResponseCode.BAD_REQUEST:
            return DataSource.BAD_REQUEST.getFailure();
          case ResponseCode.UNAUTHORIZED:
            return DataSource.UNAUTHORIZED.getFailure();
          case ResponseCode.NOTFOUND:
            return DataSource.NOTFOUND.getFailure();
          case ResponseCode.FORBIDDEN:
            return DataSource.FORBIDDEN.getFailure();
          case ResponseCode.INTERNAL_SERVER_ERROR:
            return DataSource.INTERNAL_SERVER_ERROR.getFailure();
          default:
            return DataSource.DEFAULT.getFailure();
        }

      default:
        // Handle unknown error types
        return DataSource.DEFAULT.getFailure();
    }
  }
}

class ResponseCode {
  static const int BAD_REQUEST =
      400; // The server could not understand the request due to invalid syntax

  static const int CACHE_ERROR = -6; // Error while retrieving data from cache
  static const int CANCEL = -3; // Request canceled by the client
  static const int CONNECT_TIMEOUT = -2; // Request timeout due to client delay
  // local status code
  static const int DEFAULT = -1;

  static const int FORBIDDEN =
      403; // The client does not have permission to access the requested resource

  static const int INTERNAL_SERVER_ERROR =
      500; // A generic error message indicating that the server encountered an unexpected condition

  static const int NOTFOUND = 404;
  static const int NO_CONTENT =
      204; // The server successfully processed the request, but there is no content to return
  static const int NO_INTERNET_CONNECTION =
      -7; // No internet connection available

  static const int RECEIVE_TIMEOUT = -4; // Response timeout due to server delay
  static const int SEND_TIMEOUT = -5; // Response timeout due to server delay
  // api status codes
  static const int SUCCESS = 200; // The request has succeeded

  static const int UNAUTHORIZED =
      401; // The request requires user authentication
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTHORIZED:
        return Failure(ResponseCode.UNAUTHORIZED, ResponseMessage.UNAUTHORIZED);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.NOTFOUND:
        return Failure(ResponseCode.NOTFOUND, ResponseMessage.NOTFOUND);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECEIVE_TIMEOUT:
        return Failure(
          ResponseCode.RECEIVE_TIMEOUT,
          ResponseMessage.RECEIVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.NO_INTERNET_CONNECTION,
        );
      default:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class ResponseMessage {
  static const String BAD_REQUEST = 'bad request, try again later';
  static const String CACHE_ERROR = 'cache error, try again';
  static const String CANCEL = 'request cancelled';
  static const String CONNECT_TIMEOUT = ' timeout , try again later';
  // Local status messages
  static const String DEFAULT = 'some thing wrong, try again later';

  static const String FORBIDDEN = 'forbidden, try again later';
  static const String INTERNAL_SERVER_ERROR = 'Internal Server Error';

  static const String NOTFOUND = 'requested item not found';

  static const String NO_CONTENT = 'no content';
  static const String NO_INTERNET_CONNECTION =
      'Please check your Internet Connection';

  static const String RECEIVE_TIMEOUT = ' timeout , try again later';
  static const String SEND_TIMEOUT = ' timeout , try again later';
  // API status messages
  static const String SUCCESS = 'success';

  static const String UNAUTHORIZED = 'unauthorized';
}

class ApiInternalStatus {
  static const bool FAILURE = false;
  static const bool SUCCESS = true;
}
