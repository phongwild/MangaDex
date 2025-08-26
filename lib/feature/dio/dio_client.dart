import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio? _instance;
  static Dio create({BaseOptions? options}) {
    if (_instance == null) {
      final baseOptions = BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        contentType: 'application/json',
      );
      var dio = Dio(baseOptions);
      if (kDebugMode) {
        dio.interceptors.add(
          CurlLoggerDioInterceptor(
            printOnSuccess: true,
          ),
        );
      }
      _instance = dio;
    }
    return _instance!;
  }
}

mixin NetWorkMixin {
  Future<Response> callApiPost(String endPoint, dynamic json) async {
    return await DioClient.create().post(
      endPoint,
      data: json,
    );
  }

  Future<Response> callApiPostMedia(String endPoint, dynamic json) async {
    return await DioClient.create().post(
      endPoint,
      data: json,
    );
  }

  Future<Response> callApiPut(String endPoint, dynamic json) async {
    return await DioClient.create().put(
      endPoint,
      data: json,
    );
  }

  Future<Response> callApiGet({
    required String endPoint,
    Map<String, dynamic>? json,
    String? jwtToken, // JWT token có thể null
  }) async {
    return await DioClient.create().get(
      endPoint,
      queryParameters: json,
      options: Options(
        headers: {
          if (jwtToken != null) "Cookie": jwtToken, // Thêm token nếu không null
        },
      ),
    );
  }

  Future<Response> callApiDelete(
    String endPoint, {
    Map<String, dynamic>? json,
  }) async {
    return await DioClient.create().delete(endPoint, queryParameters: json);
  }
}
