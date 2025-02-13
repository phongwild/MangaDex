import 'package:app/core/networking/interceptor/handle_unauthorized_interceptor.dart';
import 'package:app/core/networking/interceptor/logger_interceptor.dart';
import 'package:dio/dio.dart';
import 'interceptor/retry_connection_interceptor.dart';
import 'interceptor/session_interceptor.dart';

RestClient getRestClient(
  String path, {
  List<Interceptor> interceptors = const [],
  bool authenticator = true,
  bool retryWhenFail = true,
  bool handleUnauthorizedError = true,
}) {
  return RestClient(
    path,
    interceptors: [
      ...interceptors,
      LoggerInterceptor(),
      if (authenticator) SessionInterceptor(),
      if (handleUnauthorizedError) HandleUnauthorizedInterceptor(),
    ],
  );
}

class RestClient {
  late Dio _dio;

  String get baseUrl => _dio.options.baseUrl;

  BaseOptions get options => _dio.options;

  Interceptors get interceptors => _dio.interceptors;

  Dio get dio => _dio;

  RestClient(String baseUrl,
      {required List<Interceptor> interceptors,
      HttpClientAdapter? httpClientAdapter,
      Duration timeout = const Duration(seconds: 60)}) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
      receiveDataWhenStatusError: true,
      connectTimeout: timeout,
      receiveTimeout: timeout,
    );

    _dio = Dio(options);
    if (httpClientAdapter != null) {
      _dio.httpClientAdapter = httpClientAdapter;
    }

    _dio.interceptors.addAll(interceptors);
    _dio.interceptors.add(RetryOnConnectionChangeInterceptor(dio: dio));
    _dio.interceptors.add(LogInterceptor());
  }
}

Future<Response<dynamic>> computeRestfulGet(Map<String, dynamic> values) {
  String path = values[DioParamKey.path];
  String baseUrl = values[DioParamKey.baseUrl];
  Map<String, dynamic>? queryParameters = values[DioParamKey.queryParameters];
  Options? options = values[DioParamKey.options];
  final opt = BaseOptions(
    baseUrl: baseUrl,
    contentType: "application/json",
    receiveDataWhenStatusError: true,
  );
  return Dio(opt).get<dynamic>(
    path,
    queryParameters: queryParameters,
    options: options,
  );
}

Future<Response<dynamic>> computeRestfulPost(
    String baseUrl, Map<String, dynamic> values) {
  String path = values[DioParamKey.path];
  String baseUrl = values[DioParamKey.baseUrl];
  dynamic body = values[DioParamKey.body];
  Map<String, dynamic>? queryParameters = values[DioParamKey.queryParameters];
  Options? options = values[DioParamKey.options];
  final opt = BaseOptions(
    baseUrl: baseUrl,
    contentType: "application/json",
    receiveDataWhenStatusError: true,
  );
  return Dio(opt).post<dynamic>(
    path,
    queryParameters: queryParameters,
    data: body,
    options: options,
  );
}

Future<Response<dynamic>> computeRestfulPut(
    String baseUrl, Map<String, dynamic> values) {
  String path = values[DioParamKey.path];
  String baseUrl = values[DioParamKey.baseUrl];
  dynamic body = values[DioParamKey.body];
  Map<String, dynamic>? queryParameters = values[DioParamKey.queryParameters];
  Options? options = values[DioParamKey.options];
  final opt = BaseOptions(
    baseUrl: baseUrl,
    contentType: "application/json",
    receiveDataWhenStatusError: true,
  );
  return Dio(opt).put<dynamic>(
    path,
    queryParameters: queryParameters,
    data: body,
    options: options,
  );
}

class DioParamKey {
  static const path = 'path';
  static const baseUrl = 'baseUrl';
  static const options = 'options';
  static const body = 'body';
  static const queryParameters = 'queryParameters';
}
