import 'package:app/feature/utils/is_login.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  DioClient._();

  static const _prodApi = 'https://api-manga-user.vercel.app/api';
  static const _devApi = 'http://192.168.0.119:3000/api';

  static String get baseUrl {
    return kReleaseMode ? _prodApi : _devApi;
  }

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )
    ..interceptors.add(AuthInterceptor())
    ..interceptors.add(RefreshInterceptor())
    ..interceptors.add(
      CurlLoggerDioInterceptor(
        printOnSuccess: true,
      ),
    );
}

mixin NetWorkMixin {
  Dio get dio => DioClient.instance;

  Future<Response> callApiPost(String endPoint, dynamic json) {
    return dio.post(
      endPoint,
      data: json,
    );
  }

  Future<Response> callApiPut(String endPoint, dynamic json) {
    return dio.put(
      endPoint,
      data: json,
    );
  }

  Future<Response> callApiGet({
    required String endPoint,
    Map<String, dynamic>? json,
  }) {
    return dio.get(
      endPoint,
      queryParameters: json,
    );
  }

  Future<Response> callApiDelete(
    String endPoint, {
    Map<String, dynamic>? json,
  }) {
    return dio.delete(
      endPoint,
      queryParameters: json,
    );
  }
}

class AuthInterceptor extends Interceptor {
  static const noAuthEndpoints = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
    '/mangadex',
  ];
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skipAuth = noAuthEndpoints.any(
      (e) => options.path.startsWith(e),
    );

    if (skipAuth) {
      return handler.next(options);
    }
    final accessToken = IsLogin.getInstance().jwt;

    if (accessToken?.isNotEmpty == true) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}

class RefreshInterceptor extends Interceptor {
  final Dio refreshDio = Dio(
    BaseOptions(
      baseUrl: DioClient.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.requestOptions.path == '/auth/refresh') {
      return handler.next(err);
    }

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      final refreshToken = IsLogin.getInstance().refreshToken;

      if (refreshToken?.isEmpty ?? true) {
        return handler.next(err);
      }

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );

      final newAccessToken = response.data['accessToken'];

      if (newAccessToken == null) {
        throw Exception('Missing access token');
      }

      await IsLogin.getInstance().updateToken(newAccessToken);

      final request = err.requestOptions;

      request.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await DioClient.instance.fetch(request);

      return handler.resolve(retryResponse);
    } catch (_) {
      await IsLogin.getInstance().logout();
      return handler.next(err);
    }
  }
}
