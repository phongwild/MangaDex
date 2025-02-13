import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;

  RetryOnConnectionChangeInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetryOnHttpException(err)) {
      try {
        debugPrint("✨✨✨✨✨Retry call api ${err.requestOptions.uri}");

        final response = await Dio().fetch(err.requestOptions);

        debugPrint("❤️❤️❤️❤️❤️ Retry api ${err.requestOptions.uri} success");

        handler.resolve(response);
      } catch (e) {
        debugPrint("⚠️⚠️⚠️⚠️⚠️ Retry call api ${err.requestOptions.uri} fail");
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetryOnHttpException(DioException err) {
    return err.type == DioExceptionType.unknown &&
        ((err.error is HttpException &&
            (err.message ?? '').contains(
                'Connection closed before full header was received')));
  }
}
