import 'package:dio/dio.dart';
import 'package:new_3c/core/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// A singleton class for handling HTTP requests using Dio.
class HttpUtil {
  late Dio _dio;

  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() {
    return _instance;
  }

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
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
//read
  get(
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
        return response.data;
      }
      throw "something went wrong";
    } catch (e) {
      if (e is DioException) {
        // ErrorEntity eInfo = createErrorEntity(e);
        //
        // onError(eInfo);

        throw e.response!.data["message"]!;
      }
      rethrow;
    }
  }

  //create
  Future<Map<String, dynamic>> post(
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
        // ErrorEntity eInfo = createErrorEntity(e);
        //
        // onError(eInfo);

        throw e.response!.data["message"]!;
      }
      rethrow;
    }
  }

  //update
  Future<Map<String, dynamic>> patch(
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
        // ErrorEntity eInfo = createErrorEntity(e);
        //
        // onError(eInfo);
        throw e.response!.data["message"]!;
      }
      rethrow;
    }
  }

  //update
  Future<Map<String, dynamic>> put(
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
        // ErrorEntity eInfo = createErrorEntity(e);
        //
        // onError(eInfo);
        throw e.response!.data["message"]!;
      }
      rethrow;
    }
  }

  //delete
  Future<dynamic> delete(
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
        throw e.response!.data["message"]!;
      }
      rethrow;
    }
  }
}
