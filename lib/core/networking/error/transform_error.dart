import 'dart:convert';

import 'package:app/core/app_log.dart';
import 'package:dio/dio.dart';


abstract class BaseError {}

class TimeOutError extends BaseError {}

class CancelError extends BaseError {}

class DefaultError extends BaseError {}

class UnknownError extends BaseError {}

mixin BaseResponseError {
  dynamic code;
  String? message;
}

class ResponseError extends BaseError with BaseResponseError {
  dynamic status;
  dynamic data;
  int? httpStatusCode;

  String? errorMessage;

  ResponseError(
      {dynamic code, String? message, this.data, this.httpStatusCode}) {
    this.code = code;
    this.message = message;
  }

  ResponseError.fromJson(Map<String, dynamic> json) {
    code = json['ec'] ?? '';
    status = json['s'] ?? '';
    message = json['em'] ?? '';
    data = json['d'] ?? {};
    errorMessage = json['errmsg'] ?? '';
    httpStatusCode = 0;
  }

  factory ResponseError.fromDioResponse(Response response) {
    ResponseError responseError = ResponseError();
    responseError.httpStatusCode = response.statusCode;

    if (response.data is Map<String, dynamic>) {
      responseError = ResponseError.fromJson(response.data);
    } else if (response.data is String) {
      try {
        Map<String, dynamic> jsonError = jsonDecode(response.data);
        responseError = ResponseError.fromJson(jsonError);
      } on FormatException catch (e) {
        dlog(e);
      }
    }
    return responseError;
  }
}
