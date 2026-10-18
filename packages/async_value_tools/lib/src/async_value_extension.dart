import 'dart:async';

import 'package:riverpod/riverpod.dart';

import 'async_value_helper.dart';

extension AsyncValueExtension<T> on AsyncValue<T> {
  AsyncValue<(T, R)> and<R>(AsyncValue<R> other) =>
      AsyncValueHelper.merge2(this, other, (a, b) => (a, b));

  AsyncValue<(T, R0, R1)> and2<R0, R1>(
    AsyncValue<R0> other0,
    AsyncValue<R1> other1,
  ) => AsyncValueHelper.merge3(this, other0, other1, (a, b, c) => (a, b, c));

  AsyncValue<S> combine<R, S>(AsyncValue<R> other, S Function(T, R) combiner) =>
      AsyncValueHelper.merge2(this, other, (a, b) => combiner(a, b));

  AsyncValue<Z> combine2<R, Z, A, B>(
    AsyncValue<A> other0,
    AsyncValue<B> other1,
    Z Function(T, A, B) combiner,
  ) => AsyncValueHelper.merge3(
    this,
    other0,
    other1,
    (a, b, c) => combiner(a, b, c),
  );

  AsyncValue<(T, R)> zip<R>(AsyncValue<R> Function(T value) combiner) => when(
    data: (v0) => combiner(v0).whenData((v1) => (v0, v1)),
    loading: () => AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );

  AsyncValue<R> flatMap<R>(
    AsyncValue<R> Function(T value) transform, {
    bool skipLoadingOnReload = false,
  }) => map(
    data: (value) =>
        AsyncValueHelper.merge2(this, transform(value.value), (a, b) => b),
    loading: (_) => AsyncValue.loading(),
    error: (v) => AsyncValue.error(v.error, v.stackTrace),
  );

  Future<T> get asFuture => when(
    data: Future.value,
    error: Future.error,
    loading: () => Completer<T>().future,
  );

  T? get currentValue => unwrapPrevious().value;
}
