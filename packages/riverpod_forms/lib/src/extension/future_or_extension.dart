import 'dart:async';

extension FutureOrExtension<T> on FutureOr<T> {
  void handle({
    required void Function(T value) whenValue,
    required void Function(Future<T> value) whenFuture,
  }) {
    if (this is Future<T>) {
      whenFuture(this as Future<T>);
    } else {
      whenValue(this as T);
    }
  }
}
