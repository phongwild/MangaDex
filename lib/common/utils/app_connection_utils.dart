import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionUtils {
  static final ConnectionUtils _singleton = ConnectionUtils._internal();
  factory ConnectionUtils() => _singleton;
  ConnectionUtils._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityResult? _type;

  bool get isActive => _type != null && _type != ConnectivityResult.none;
  bool get isDataPlan => _type == ConnectivityResult.mobile;
  ConnectivityResult get type => _type ?? ConnectivityResult.none;

  final List<void Function(bool isActive)> _callbacks = [];

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
      final results = await _connectivity.checkConnectivity();
      return results.isNotEmpty &&
          (results.contains(ConnectivityResult.mobile) ||
              results.contains(ConnectivityResult.wifi));
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return defaultValue ?? true;
    }
  }

  Future<void> init() async {
    if (_subscription != null) return;

    // Gán trạng thái mạng ban đầu (fix lỗi)
    final results = await _connectivity.checkConnectivity();
    _type = results.isNotEmpty ? results.first : ConnectivityResult.none;

    // Lắng nghe thay đổi kết nối mạng
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      if (_type != result) {
        _type = result;
        for (var callback in _callbacks) {
          callback.call(isActive);
        }
      }
    });
  }
}
