class SocketSubscriber<T> {
  final Stream<T> streamData;
  final Function() dispose;

  // ignore: sort_constructors_first
  SocketSubscriber(this.streamData, this.dispose);
}
