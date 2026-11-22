import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class Value<T> {
  Value();

  factory Value.sync(T value) = SyncValue<T>;

  factory Value.future(Future<T> value) = FutureValue<T>;

  factory Value.riverpod(AsyncValue<T> Function(Ref ref) value) =
      RiverpodValue<T>;
}

final class SyncValue<T>(final T value) extends Value<T> {}

final class FutureValue<T>(final Future<T> value) extends Value<T> {}

final class RiverpodValue<T>(final AsyncValue<T> Function(Ref ref) value)
    extends Value<T> {}
