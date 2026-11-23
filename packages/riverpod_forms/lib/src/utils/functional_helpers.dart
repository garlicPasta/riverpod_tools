import 'dart:developer';

@pragma("vm:prefer-inline")
TResult? notNull<TValue, TResult>(
  TValue? value, {
  required TResult Function(TValue value) then,
}) => (value == null) ? null : then(value);

@pragma("vm:prefer-inline")
TResult? notNull2<TValue0, TValue1, TResult>(
  TValue0? value0,
  TValue1? value1, {
  required TResult Function(TValue0 value, TValue1 value1) then,
}) => (value0 == null || value1 == null) ? null : then(value0, value1);

@pragma("vm:prefer-inline")
TResult? maybeNull<TValue0, TValue1, TResult>(
  TValue0? value0, {
  required TResult? Function(TValue0 value) then,
}) => (value0 == null) ? null : then(value0);

@pragma("vm:prefer-inline")
TResult? maybeNull2<TValue0, TValue1, TResult>(
  TValue0? value0,
  TValue1? value1, {
  required TResult? Function(TValue0 value, TValue1 value1) then,
}) => (value0 == null || value1 == null) ? null : then(value0, value1);

@pragma("vm:prefer-inline")
TResult notNullOr<TValue, TResult>(
  TValue? value, {
  required TResult Function(TValue value) then,
  required TResult orElse,
}) => (value == null) ? orElse : then(value);

@pragma("vm:prefer-inline")
T logIt<T>(T value) {
  log(value.toString());
  return value;
}
