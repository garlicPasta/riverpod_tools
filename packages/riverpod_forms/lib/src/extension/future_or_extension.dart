import 'dart:async';

extension FutureOrExtension<T> on FutureOr<T> {
  void handle({
    required void Function() beforeValue,
    required void Function(T value) onValue,
    required void Function(Object error)? onError,
  }) {
    if (this is Future<T>) {
      beforeValue();
      (this as Future<T>).then(onValue).catchError((e) {
        onError?.call(e);
      });
    } else {
      onValue(this as T);
    }
  }
}
