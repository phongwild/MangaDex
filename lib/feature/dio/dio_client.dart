import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  // Singleton instance for connection pooling
  static Dio? _instance;
  
  static Dio create({BaseOptions? options}) {
    // Reuse existing instance for better performance on low-end devices
    if (_instance != null && options == null) {
      return _instance!;
    }
    
    final baseOptions = options ?? BaseOptions(
      // Optimized timeouts for low-end devices
      connectTimeout: kReleaseMode 
          ? const Duration(seconds: 15)  // Shorter timeout in production
          : const Duration(seconds: 30),
      receiveTimeout: kReleaseMode 
          ? const Duration(seconds: 30)  // Shorter timeout in production  
          : const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 15),
      
      // Performance optimizations
      persistentConnection: true,
      maxRedirects: 3,
      
      // Headers optimization
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // Enable compression for faster data transfer
        'Accept-Encoding': 'gzip, deflate',
      },
      
      // Response data handling
      responseType: ResponseType.json,
      receiveDataWhenStatusError: true,
    );
    
    var dio = Dio(baseOptions);

    // Only add logging in debug mode to improve performance
    if (kDebugMode) {
      dio.interceptors.add(
        CurlLoggerDioInterceptor(
          printOnSuccess: false, // Reduce console output
        ),
      );
    }

    // Cache instance for reuse
    if (options == null) {
      _instance = dio;
    }

    return dio;
  }
  
  // Method to clear cached instance if needed
  static void clearCache() {
    _instance = null;
  }
}

mixin NetWorkMixin {
  // Cached Dio instance for reuse
  static Dio? _cachedDio;
  
  Dio get _dio {
    _cachedDio ??= DioClient.create();
    return _cachedDio!;
  }

  Future<Response> callApiPost(String endPoint, dynamic json) async {
    return await _dio.post(
      endPoint,
      data: json,
      options: Options(
        // Optimize for low-end devices
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  Future<Response> callApiPostMedia(String endPoint, dynamic json) async {
    return await _dio.post(
      endPoint,
      data: json,
      options: Options(
        contentType: 'multipart/form-data',
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  Future<Response> callApiPut(String endPoint, dynamic json) async {
    return await _dio.put(
      endPoint,
      data: json,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  Future<Response> callApiGet({
    required String endPoint,
    Map<String, dynamic>? json,
    String? jwtToken,
  }) async {
    // Create optimized options for GET requests
    final options = Options(
      headers: {
        if (jwtToken != null) "Cookie": jwtToken,
      },
      validateStatus: (status) => status != null && status < 500,
      // Enable caching for GET requests
      extra: {'refresh': false},
    );

    return await _dio.get(
      endPoint,
      queryParameters: json,
      options: options,
    );
  }

  Future<Response> callApiDelete(
    String endPoint, {
    Map<String, dynamic>? json,
  }) async {
    return await _dio.delete(
      endPoint, 
      queryParameters: json,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
  
  // New method for lightweight requests
  Future<Response> callApiGetOptimized({
    required String endPoint,
    Map<String, dynamic>? json,
    String? jwtToken,
    Duration? timeout,
  }) async {
    final customTimeout = timeout ?? const Duration(seconds: 10);
    
    return await _dio.get(
      endPoint,
      queryParameters: json,
      options: Options(
        headers: {
          if (jwtToken != null) "Cookie": jwtToken,
        },
        sendTimeout: customTimeout,
        receiveTimeout: customTimeout,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
}
