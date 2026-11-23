import 'dart:developer';

@pragma("vm:prefer-inline")
TResult? whenNull<TValue, TResult>(
  TValue? value, {
  required TResult Function(TValue value) then,
}) => (value == null) ? null : then(value);

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
