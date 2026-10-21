import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/form_value.dart';
import 'package:riverpod_forms/src/models/validators.dart';

final class IsEqual();
final class IsNotEqual();

Validator<VALUE, IsEqual> makeIsEqual<VALUE>(
  FormValue<VALUE, Object?, dynamic> other,
) => .riverpod(
  (Ref ref, VALUE? value) =>
      AsyncValue.data(other.watchValue(ref) != value ? IsEqual() : null),
);

Validator<VALUE, IsNotEqual> makeIsNotEqual<VALUE>(
  FormValue<VALUE, Object?, dynamic> other,
) => .riverpod(
  (Ref ref, VALUE? value) =>
      AsyncValue.data(other.watchValue(ref) == value ? IsNotEqual() : null),
);

final class IsRequired {}

Validator<T, IsRequired> makeIsRequiredValidator<T>() => .sync((T? value) {
  if (value == null || (value is String && value.isEmpty)) {
    return IsRequired();
  }
  return null;
});
