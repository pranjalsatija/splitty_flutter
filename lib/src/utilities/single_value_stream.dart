import 'dart:async';

class SingleValueStream<T> {
  Stream<T> get backingStream => _controller.stream;
  StreamController<T> _controller;

  SingleValueStream(T value) {
    _controller = StreamController<T>(
      onListen: () {
        _controller.add(value);
      }
    );
  }

  static SingleValueStream<T> from<T>(T value) => SingleValueStream(value);
}