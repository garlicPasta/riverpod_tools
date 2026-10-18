import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueHelper {
  static AsyncValue<M> merge2<M, A, B>(
    AsyncValue<A> v1,
    AsyncValue<B> v2,
    M Function(A a, B b) merge,
  ) {
    AsyncValue<M>? asyncValue;
    if (v1.hasError || v2.hasError) {
      log('error when merging values: ${v1.error ?? v2.error}');

      asyncValue = AsyncError<M>(
        (v1.error ?? v2.error)!,
        (v1.stackTrace ?? v2.stackTrace)!,
      );
    }

    if (v1.isLoading || v2.isLoading) {
      asyncValue = AsyncLoading<M>();
    }

    if (v1.hasValue && v2.hasValue) {
      M mergedValue = merge.call(v1.requireValue, v2.requireValue);
      // ignore: invalid_use_of_internal_member
      return asyncValue?.copyWithPrevious(AsyncData(mergedValue)) ??
          AsyncData(mergedValue);
    }
    return asyncValue ?? AsyncLoading<M>();
  }

  static AsyncValue<M> merge3<M, A, B, C>(
    AsyncValue<A> v1,
    AsyncValue<B> v2,
    AsyncValue<C> v3,
    M Function(A a, B b, C c) merge,
  ) => merge2(
    merge2(v1, v2, (a, b) => (a, b)),
    v3,
    (t, c) => merge(t.$1, t.$2, c),
  );

  static AsyncValue<M> merge4<M, A, B, C, D>(
    AsyncValue<A> v1,
    AsyncValue<B> v2,
    AsyncValue<C> v3,
    AsyncValue<D> v4,
    M Function(A a, B b, C c, D d) merge,
  ) => merge2(
    merge2(v1, v2, (a, b) => (a, b)),
    merge2(v3, v4, (a, b) => (a, b)),
    (a, b) => merge(a.$1, a.$2, b.$1, b.$2),
  );

  static AsyncValue<List<M>> wait<M>(Iterable<AsyncValue<M>> values) {
    List<M> results = [];
    for (var v in values) {
      if (v.hasError) {
        return AsyncError(v.error!, v.stackTrace!);
      }
      if (v.hasValue) {
        results.add(v.requireValue);
      } else {
        return const AsyncLoading();
      }
    }
    return AsyncData<List<M>>(results);
  }

  // static AsyncValue<M> flatten<M>(
  //   AsyncValue<AsyncValue<M>> value, [
  //   bool skipLoadingOnReload = true,
  // ]) => value.when(
  //   skipLoadingOnReload: skipLoadingOnReload,
  //   data: (d) => d.when(
  //     skipLoadingOnReload: skipLoadingOnReload,
  //     data: (value) => AsyncData(value),
  //     error: AsyncError.new,
  //     loading: AsyncLoading.new,
  //   ),
  //   error: AsyncError.new,
  //   loading: AsyncLoading.new,
  // );
}
