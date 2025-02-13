import 'package:rxdart/rxdart.dart';

import 'socket_subscriber.dart';

/// Private class
class _SocketNotifier<T> {
  final PublishSubject<T> observer;

  _SocketNotifier(this.observer);
}

/// Private class
class SocketObservationPair<T> {
  final String uniqueId;
  final PublishSubject<T> _dataSource;
  final Function() _dispose;
  late SocketSubscriber<T> subscriber;
  // ignore: library_private_types_in_public_api
  late _SocketNotifier<T> notifier;

  SocketObservationPair(
      {required this.uniqueId,
      required PublishSubject<T> dataSource,
      required Function() onDispose})
      : _dataSource = dataSource,
        _dispose = onDispose {
    notifier = _SocketNotifier(_dataSource);
    subscriber = SocketSubscriber(_dataSource.stream, _onSubscriberDispose);
  }

  void _onSubscriberDispose() {
    _dispose();
  }
}
