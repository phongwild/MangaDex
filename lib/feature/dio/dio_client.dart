import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio create({BaseOptions? options}) {
    var dio = Dio(options);
    if (options != null) {
      dio.options = options;
    }

    if (kDebugMode) {
      dio.interceptors.add(
        CurlLoggerDioInterceptor(
          printOnSuccess: true,
        ),
      );
    }

    return dio;
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
    return await DioClient.create(
      options: BaseOptions(
        headers: {
          if (jwtToken != null) "Cookie": jwtToken, // Thêm token nếu không null
        },
      ),
    ).get(
      endPoint,
      queryParameters: json,
    );
  }

  Future<Response> callApiDelete(
    String endPoint, {
    Map<String, dynamic>? json,
  }) async {
    return await DioClient.create().delete(endPoint, queryParameters: json);
  }
}
