import 'dart:io';

import 'package:dio/dio.dart';

class HandleUnauthorizedInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // final globalBloc = sl.get<GlobalBloc>();

    if (err.response?.statusCode == HttpStatus.unauthorized) {
      // globalBloc.expireController.add(DialogContent(DialogType.expire));
      return handler.reject(err);
    }

    // if (err.response?.data is Map &&
    //     err.response?.data?['code'] == AppCo) {
    //   globalBloc.expireController.add(
    //     DialogContent(
    //       DialogType.maintenance,
    //       content: err.response?.data['message'],
    //     ),
    //   );
    //   return handler.reject(err);
    // }

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
