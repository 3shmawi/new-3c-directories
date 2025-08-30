import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:new_3c/core/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpUtil {
  late Dio _dio;

  int counter = 0;
  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() {
    return _instance;
  }

  HttpUtil._internal() {
    final options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    );
    _dio = Dio(options);

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.statusCode == 200) {
        log('${++counter}');
        return response.data;
      }
      throw "something went wrong";
    } catch (e) {
      if (e is DioException) {
        log(e.response!.data["message"]!);
      }
      rethrow;
    }
  }

  Future<T?> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      throw "something went wrong";
    } catch (e) {
      if (e is DioException) {
        log(e.response!.data["message"]!);
      }
      rethrow;
    }
  }

  Future<T?> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      throw "something went wrong";
    } catch (e) {
      if (e is DioException) {
        log(e.response!.data["message"]!);
      }
      rethrow;
    }
  }

  Future<T?> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw "something went wrong";
    } catch (e) {
      if (e is DioException) {
        log(e.response!.data["message"]!);
      }
      rethrow;
    }
  }

  Future<T?> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw "something went wrong";
    } catch (e) {
      if (e is DioException) {
        log(e.response!.data["message"]!);
      }
      rethrow;
    }
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";

  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";

    return "Exception code $code, $message";
  }
}

ErrorEntity createErrorEntity(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return ErrorEntity(code: -1, message: "Connection timed out");

    case DioExceptionType.sendTimeout:
      return ErrorEntity(code: -1, message: "Send timed out");

    case DioExceptionType.receiveTimeout:
      return ErrorEntity(code: -1, message: "Receive timed out");

    case DioExceptionType.badCertificate:
      return ErrorEntity(code: -1, message: "Bad SSL certificates");

    case DioExceptionType.badResponse:
      switch (error.response!.statusCode) {
        case 400:
          return ErrorEntity(
              code: 400, message: error.response!.statusMessage!);
        case 401:
          return ErrorEntity(code: 401, message: "Permission denied");
        case 500:
          return ErrorEntity(code: 500, message: "Server internal error");
      }
      return ErrorEntity(
          code: error.response!.statusCode!, message: "Server bad response");

    case DioExceptionType.cancel:
      return ErrorEntity(code: -1, message: "Server canceled it");

    case DioExceptionType.connectionError:
      return ErrorEntity(code: -1, message: "Connection error");

    case DioExceptionType.unknown:
      return ErrorEntity(code: -1, message: "Unknown error");
  }
}

void onError(ErrorEntity eInfo) {
  log('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');

  switch (eInfo.code) {
    case 400:
      log("Bad Request");

    case 401:
      log("Unauthorized");

    case 403:
      log("Forbidden");

    case 404:
      log("Not Found");

    case 405:
      log("Method Not Allowed");

    case 408:
      log("Request Timeout");

    case 409:
      log("Conflict");

    case 410:
      log("Gone");

    case 500:
      log("Internal Server Error");

    case 501:
      log("Not Implemented");

    case 502:
      log("Bad Gateway");

    case 503:
      log("Service Unavailable");

    case 504:
      log("Gateway Timeout");

    case 505:
      log("HTTP Version Not Supported");

    default:
      log("Unknown Error");
  }
}
