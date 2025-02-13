import 'package:dio/dio.dart';
import 'transform_error.dart';

class HandleError {
  static dynamic from<D>(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return TimeOutError();
        case DioExceptionType.cancel:
          return CancelError();
        case DioExceptionType.badResponse:
          if (D == ResponseError) {
            return ResponseError.fromDioResponse(e.response!);
          } else if (e.response?.data is Map) {
            return ResponseError.fromJson(e.response!.data);
          }
          return ResponseError();
        case DioExceptionType.unknown:
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionError:
          return DefaultError();
      }
    }
    return e;
  }
}
