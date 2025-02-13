import 'package:flutter/foundation.dart';

void dlog(var value) {
  if (kDebugMode) {
    print('MyLOG: ${value.toString()}');
  }
}
