import 'dart:async';
import 'dart:io';

import 'package:app/core/app_log.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService instance = NetworkService._internal();
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast(
    onListen: () => dlog("📡 Listener được đăng ký cho connectionStream"),
  );

  late bool isConnected;

  Stream<bool> get connectionStream => _connectionController.stream;

  Future<void> init() async {
    isConnected = await _hasInternetAccess();
    dlog("Khởi động NetworkService: isConnected = $isConnected");
    _connectivity.onConnectivityChanged.listen((result) async {
      bool hasInternet =
          result != ConnectivityResult.none && await _hasInternetAccess();
      dlog("Mạng thay đổi: $result, hasInternet = $hasInternet");
      if (isConnected != hasInternet) {
        isConnected = hasInternet;
        _connectionController.add(isConnected);
        dlog("Phát sự kiện: isConnected = $isConnected");
      }
    });
  }

  Future<bool> _hasInternetAccess() async {
    try {
      dlog("🔎 Kiểm tra truy cập Internet...");
      final result = await InternetAddress.lookup('google.com');
      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      dlog("🌍 Truy cập Internet: $hasInternet");
      return hasInternet;
    } catch (e) {
      dlog("❌ Không thể kết nối Internet: $e");
      return false;
    }
  }

  void dispose() {
    _connectionController.close();
  }
}
