import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionUtils {
  static final ConnectionUtils _singleton = ConnectionUtils._internal();

  factory ConnectionUtils() {
    return _singleton;
  }

  ConnectionUtils._internal();

  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityResult? _type;

  bool get isActive => _type != null && _type != ConnectivityResult.none;

  bool get isDataPlan => _type == ConnectivityResult.mobile;

  ConnectivityResult get type => _type ?? ConnectivityResult.none;

  final _callbacks = <void Function(bool isActive)>[];

  void addListener(void Function(bool isActive) callback,
      {bool addLastEvent = false}) {
    _callbacks.add(callback);
    if (addLastEvent) callback.call(isActive);
  }

  void removeListener(void Function(bool isActive) callback) {
    _callbacks.remove(callback);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _callbacks.clear();
    _type = null;
  }

  Future<bool> checkConnection(
      {bool? defaultValue = true, int delay = 0}) async {
    try {
      if (delay > 0) await Future.delayed(Duration(seconds: delay));

      final result = await Connectivity().checkConnectivity();

      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi;
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return defaultValue ?? true;
    }
  }

  Future<void> init() async {
    if (_subscription != null) return;

    _subscription = Connectivity().onConnectivityChanged.listen(
      (result) {
        if (_type != result) {
          _type = result;

          for (var e in _callbacks) {
            e.call(isActive);
          }
        }
      },
    );
  }
}
