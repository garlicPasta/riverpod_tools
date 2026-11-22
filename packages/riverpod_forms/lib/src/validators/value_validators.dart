import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/form_value.dart';
import 'package:riverpod_forms/src/models/validators.dart';

final class IsEqual();
final class IsNotEqual();

RiverpodValidator<VALUE, IsEqual> isEqual<VALUE>(
  FormValue<VALUE?, Object?, dynamic> other,
) => .new(
  (Ref ref, VALUE? value) =>
      AsyncValue.data(other.watchValue(ref) != value ? IsEqual() : null),
);

RiverpodValidator<VALUE, IsNotEqual> isNotEqual<VALUE>(
  FormValue<VALUE?, Object?, dynamic> other,
) => .new(
  (Ref ref, VALUE? value) =>
      AsyncValue.data(other.watchValue(ref) == value ? IsNotEqual() : null),
);

final class IsRequired {}

SyncValidator<T, IsRequired> isRequired<T>() => .new((T? value) {
  if (value == null || (value is String && value.isEmpty)) {
    return IsRequired();
  }
  return null;
});
