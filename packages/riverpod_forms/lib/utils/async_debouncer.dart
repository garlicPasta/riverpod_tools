import 'dart:developer' show log;

import 'package:async/async.dart';
import 'package:riverpod_forms/typedefs.dart';

class AsyncDebouncer<T> {
  final Duration? _delay;
  CancelableOperation<T>? _operation;

  AsyncDebouncer([this._delay]);

  Future<T> run(Lazy<Future<T>> task) {
    log('AsyncDebouncer run called');
    if (!(_operation?.isCompleted ?? true)) {
      _operation?.cancel();
    }
    _operation = CancelableOperation.fromFuture(
      Future.delayed(_delay ?? Duration(milliseconds: 200)),
      onCancel: () {
        log('AsyncDebouncer operation cancelled');
      },
    ).then((_) => task());
    return _operation!.value;
  }
}
