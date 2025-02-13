import 'package:app/core/networking/error/transform_error.dart';

class BEBaseResponse with BaseResponseError {
  dynamic status;
  dynamic data;
  dynamic httpStatus;

  BEBaseResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'];
    httpStatus = json['httpStatus'];
  }

  BEBaseResponse({dynamic code, String? message, this.status, this.data}) {
    this.code = int.tryParse(code.toString())?.abs();
    this.message = message;
  }

  bool isSuccess() {
    return code?.toString() == '0' ||
        code?.toString() == '200' ||
        status?.toString() == '1';
  }

  bool is503() {
    return (httpStatus ?? '') == '503';
  }
}
