import 'package:app/common/extensions/list_extensions.dart';
import 'package:app/common/utils/app_connection_utils.dart';
import 'package:app/core/app_log.dart';
import 'package:app/core/socket/socket_subscriber.dart';
import 'package:app/domain/env_config/env_url.dart';
import 'package:app/global/router/app_router.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_client;
import 'package:uuid/uuid.dart';

import 'socket_data.dart';
import 'socket_data_center.dart';

enum ISocketChannel {
  oddLotStockInfo,
  stockinfo,
  marketData,
  marketinfo,
  marketVolume,
}

extension ISocketChannelExt on ISocketChannel {
  String get name {
    switch (this) {
      case ISocketChannel.oddLotStockInfo:
        return 'oddlot_stockinfo';
      case ISocketChannel.stockinfo:
        return 'stockinfo';
      case ISocketChannel.marketData:
        return 'marketdata';
      case ISocketChannel.marketinfo:
        return 'marketinfo';
      case ISocketChannel.marketVolume:
        return 'marketVolume';
      default:
        return '';
    }
  }

  String get value {
    switch (this) {
      case ISocketChannel.oddLotStockInfo:
        return 'oddlot_si';
      case ISocketChannel.stockinfo:
        return 'stockInfo';
      case ISocketChannel.marketData:
        return 'aggTrade';
      case ISocketChannel.marketinfo:
        return 'aggMarket';
      case ISocketChannel.marketVolume:
        return 'marketVolume';
      default:
        return '';
    }
  }
}

class ISocketConnect {
  static final ISocketConnect instance = ISocketConnect._internal();

  factory ISocketConnect() => instance;

  ISocketConnect._internal();

  io_client.Socket? _socket;

  bool _forceDisconnect = false;

  /// item1: channel name
  /// item2: symbol
  final Map<Tuple2<String, String>,
      List<SocketObservationPair<ISocketStockData>>> _stockSubscribedList = {};

  final _pendingSubscribe = <Tuple2<String, String>>[];

  void connect() {
    _forceDisconnect = false;

    if (_socket != null && _socket!.connected) return;

    _initSocket();
    _connect();
  }

  /// still keep old listener when disconnect socket
  void disconnect() {
    _forceDisconnect = true;

    if (_socket != null) {
      _socket?.dispose();
      _socket = null;
    }
  }

  /// only call this method when logout
  /// remove all listener and disconnect
  void destroy() {
    _stockSubscribedList.clear();
    _pendingSubscribe.clear();

    disconnect();
  }

  void _initSocket() {
    final url = sl<EnvUrl>().socketUrl();

    _socket = io_client.io(
      url,
      io_client.OptionBuilder()
          .enableForceNew()
          .enableForceNewConnection()
          .enableAutoConnect()
          .enableReconnection()
          .setTransports(['websocket'])
          .setPath('/stream')
          .build(),
    );
  }

  void _connect() {
    _socket?.on('connect', (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET IV CONNECTED');

      _resubscribeSocket();
      _subscribePendingChannel();
    });

    _socket?.onReconnect((data) {
      dlog('❤️❤️❤️❤️❤️ SOCKET IV RECONNECT');
      _resubscribeSocket();
      _subscribePendingChannel();
    });

    _socket?.on('connect_timeout', (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET IV CONNECT TIMEOUT');

      reconnect();
    });

    _socket?.on('error', (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET IV ERROR');
    });

    _socket?.on('reconnecting', (_) {
      dlog('❤️❤️❤️❤️❤️ SOCKET IV RECONNECTING');
    });

    _socket?.on('disconnect', (_) {
      dlog('⚠️⚠️⚠️⚠️⚠️ SOCKET IV DISCONNECT');

      reconnect();
    });

    _socket?.on('reconnect_failed', (_) {
      dlog('⚠️⚠️⚠️⚠️⚠️ SOCKET IV RECONNECT FAILED');
    });

    _socket?.on('reconnect_error', (_) {
      dlog('⚠️⚠️⚠️⚠️⚠️ SOCKET IV RECONNECT ERROR');
    });

    _socket?.on('reconnect_attempt', (_) {
      dlog('✨✨✨✨✨️ SOCKET IV RECONNECT ATTEMPT');
    });

    _socket?.on('message', _transformStockData);
  }

  void reconnect() async {
    if (_forceDisconnect) return;

    if (_socket != null) disconnect();

    final hasInternet = await ConnectionUtils().checkConnection(delay: 2);

    if (hasInternet) connect();
  }

  void _subscribePendingChannel() {
    try {
      if (_pendingSubscribe.isNullOrEmpty) return;

      for (final channel in _pendingSubscribe) {
        _subscribeStock(channel: channel.value1, symbol: channel.value2);
      }

      _pendingSubscribe.clear();
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  SocketSubscriber<ISocketStockData> addListener(
      String symbol, ISocketChannel channel) {
    final channelName = channel.name;

    final String uniqueId = const Uuid().v1();

    final pair = SocketObservationPair<ISocketStockData>(
      uniqueId: uniqueId,
      dataSource: PublishSubject<ISocketStockData>(),
      onDispose: () => _removeListener(symbol, channelName, uniqueId),
    );

    final observers = _stockSubscribedList[Tuple2(channelName, symbol)];

    if (observers.isNullOrEmpty) {
      _stockSubscribedList[Tuple2(channelName, symbol)] = [pair];
      _subscribeStock(channel: channelName, symbol: symbol);
    } else {
      _stockSubscribedList[Tuple2(channelName, symbol)]!.add(pair);
    }

    return pair.subscriber;
  }

  void _resubscribeSocket() {
    if (_stockSubscribedList.isEmpty) return;

    /// item1: channel
    /// item2: symbol
    for (final channel in _stockSubscribedList.keys) {
      _subscribeStock(
        channel: channel.value1,
        symbol: channel.value2,
        addPendingWhenNoConnect: false,
      );
    }
  }

  void _removeListener(String symbol, String channel, String uniqueId) {
    final observers = _stockSubscribedList[Tuple2(channel, symbol)];

    if (!observers.isNullOrEmpty) {
      observers!.removeWhere((e) => e.uniqueId == uniqueId);

      if (observers.isNullOrEmpty) {
        _stockSubscribedList.remove(Tuple2(channel, symbol));
        _unsubscribeStock(symbol: symbol, channel: channel);
      }
    }
  }

  void _subscribeStock({
    required String symbol,
    required String channel,
    bool addPendingWhenNoConnect = true,
  }) {
    try {
      final tuple = Tuple2(channel, symbol);

      if (_socket != null && _socket!.connected) {
        _socket!.emitWithAck(
          'join',
          {'marketId': symbol, 'channel': channel},
          ack: (data) {},
        );
      } else if (addPendingWhenNoConnect &&
          !_pendingSubscribe.contains(tuple)) {
        _pendingSubscribe.add(tuple);
      }
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _unsubscribeStock({required String symbol, required String channel}) {
    if (_socket != null && _socket!.connected) {
      _socket!.emitWithAck(
        'unsubscribe',
        {'marketId': symbol, 'channel': channel},
        ack: (data) {},
      );
    }
  }

  void _transformStockData(dynamic data) {
    try {
      if (data == null || data is! Map<String, dynamic>) return;

      final channelValue = data['e'];

      final symbol = data['sb'] ?? data['mc'] ?? data['s'];

      Tuple2<String, String>? tuple;

      ISocketStockData? iSocketStockData;

      if (channelValue == ISocketChannel.oddLotStockInfo.value) {
        tuple = Tuple2(ISocketChannel.oddLotStockInfo.name, symbol);
        iSocketStockData = IStockInfoData.fromJson(data);
      } else if (channelValue == ISocketChannel.stockinfo.value) {
        tuple = Tuple2(ISocketChannel.stockinfo.name, symbol);
        iSocketStockData = IStockInfoData.fromJson(data);
      } else if (channelValue == ISocketChannel.marketData.value) {
        tuple = Tuple2(ISocketChannel.marketData.name, symbol);
        iSocketStockData = IMarketData.fromJson(data);
      } else if (channelValue == ISocketChannel.marketinfo.value) {
        tuple = Tuple2(ISocketChannel.marketinfo.name, symbol);
        iSocketStockData = IMarketInfoData.fromJson(data);
      } else if (channelValue == ISocketChannel.marketVolume.value) {
        tuple = Tuple2(ISocketChannel.marketVolume.name, symbol);
        iSocketStockData = IMarketInfoData.fromJson(data);
      }

      final observers = _stockSubscribedList[tuple];

      if (observers.isNullOrEmpty || iSocketStockData == null) return;

      for (final observer in observers!) {
        observer.notifier.observer.add(iSocketStockData);
      }
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
