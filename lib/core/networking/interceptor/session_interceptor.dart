import 'package:app/global/app_session/app_session.dart';
import 'package:dio/dio.dart';

class SessionInterceptor implements InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? tokenType = Session().tokenType;
    String? accessToken = Session().accessToken;

    if (tokenType != null && accessToken != null) {
      options.headers.addAll(<String, dynamic>{
        'Authorization': '$tokenType $accessToken',
      });
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
