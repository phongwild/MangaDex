import 'package:app/core/networking/interceptor/handle_unauthorized_interceptor.dart';
import 'package:app/core/networking/interceptor/logger_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      // Only add logger in debug mode for better performance
      if (!kReleaseMode) LoggerInterceptor(),
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
      Duration? timeout}) {
    
    // Optimized timeouts for low-end devices
    final optimizedTimeout = timeout ?? (kReleaseMode 
        ? const Duration(seconds: 20)  // Shorter timeout in production
        : const Duration(seconds: 60));
    
    final options = BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
      receiveDataWhenStatusError: true,
      
      // Optimized timeouts
      connectTimeout: optimizedTimeout,
      receiveTimeout: optimizedTimeout,
      sendTimeout: Duration(seconds: optimizedTimeout.inSeconds ~/ 2),
      
      // Performance optimizations
      persistentConnection: true,
      maxRedirects: 3,
      
      // Headers for better performance
      headers: {
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip, deflate',
        'Connection': 'keep-alive',
      },
      
      // Validate status for better error handling
      validateStatus: (status) => status != null && status < 500,
    );

    _dio = Dio(options);
    if (httpClientAdapter != null) {
      _dio.httpClientAdapter = httpClientAdapter;
    }

    _dio.interceptors.addAll(interceptors);
    
    // Only add retry interceptor if needed
    if (retryWhenFail) {
      _dio.interceptors.add(RetryOnConnectionChangeInterceptor(dio: _dio));
    }
    
    // Conditional logging for performance
    if (!kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: false,  // Reduce logging overhead
        responseBody: false, // Reduce logging overhead
        error: true,
        requestHeader: false,
        responseHeader: false,
      ));
    }
  }
}

// Optimized compute functions with better performance
Future<Response<dynamic>> computeRestfulGet(Map<String, dynamic> values) {
  String path = values[DioParamKey.path];
  String baseUrl = values[DioParamKey.baseUrl];
  Map<String, dynamic>? queryParameters = values[DioParamKey.queryParameters];
  Options? options = values[DioParamKey.options];
  
  final opt = BaseOptions(
    baseUrl: baseUrl,
    contentType: "application/json",
    receiveDataWhenStatusError: true,
    
    // Optimized timeouts
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 10),
    
    // Performance headers
    headers: {
      'Accept': 'application/json',
      'Accept-Encoding': 'gzip, deflate',
    },
    
    validateStatus: (status) => status != null && status < 500,
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
  String baseUrlParam = values[DioParamKey.baseUrl];
  dynamic body = values[DioParamKey.body];
  Map<String, dynamic>? queryParameters = values[DioParamKey.queryParameters];
  Options? options = values[DioParamKey.options];
  
  final opt = BaseOptions(
    baseUrl: baseUrlParam,
    contentType: "application/json",
    receiveDataWhenStatusError: true,
    
    // Optimized timeouts
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 15),
    
    // Performance headers
    headers: {
      'Accept': 'application/json',
      'Accept-Encoding': 'gzip, deflate',
    },
    
    validateStatus: (status) => status != null && status < 500,
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
  String baseUrlParam = values[DioParamKey.baseUrl];
  dynamic body = values[DioParamKey.body];
  Map<String, dynamic>? queryParameters = values[DioParamKey.queryParameters];
  Options? options = values[DioParamKey.options];
  
  final opt = BaseOptions(
    baseUrl: baseUrlParam,
    contentType: "application/json",
    receiveDataWhenStatusError: true,
    
    // Optimized timeouts
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 15),
    
    // Performance headers
    headers: {
      'Accept': 'application/json',
      'Accept-Encoding': 'gzip, deflate',
    },
    
    validateStatus: (status) => status != null && status < 500,
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
