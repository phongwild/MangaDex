import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LoggerInterceptor extends PrettyDioLogger {
  LoggerInterceptor()
      : super(
          requestHeader: kDebugMode ? true : false,
          requestBody: kDebugMode ? true : false,
          responseBody: kDebugMode ? true : false,
          responseHeader: kDebugMode ? true : false,
          error: kDebugMode ? true : false,
          compact: kDebugMode ? true : false,
        );
}
