import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/providers/as_future_provider.dart';

sealed class Value<T> {
  Value();

  AsyncValue<T> watch(Ref ref);

  factory Value.sync(T value) = SyncValue<T>;

  factory Value.future(Future<T> value) = FutureValue<T>;

  factory Value.riverpod(AsyncValue<T> Function(Ref ref) value) =
      RiverpodValue<T>;
}

final class SyncValue<T>(final T value) extends Value<T> {
  AsyncValue<T> watch(Ref ref) => AsyncValue.data(value);
}

final class FutureValue<T>(final Future<T> value) extends Value<T> {
  late final _key = EqualFuture(value);

  AsyncValue<T> watch(Ref ref) =>
      ref.watch(futureToAsyncDataProvider(_key)).as<T>();
}

final class RiverpodValue<T>(final AsyncValue<T> Function(Ref ref) value)
    extends Value<T> {
  AsyncValue<T> watch(Ref ref) => value(ref);
}
