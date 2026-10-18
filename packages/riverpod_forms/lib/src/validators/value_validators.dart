import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';

final class IsEqual();
final class IsNotEqual();

FormValueValidator<VALUE, IsEqual> makeIsEqual<VALUE>(
  FormValueProxy<VALUE, Object?> other,
) =>
    (Ref ref, VALUE? value) =>
        AsyncValue.data(other.watchValue(ref) != value ? IsEqual() : null);

FormValueValidator<VALUE, IsNotEqual> makeIsNotEqual<VALUE>(
  FormValueProxy<VALUE, Object?> other,
) =>
    (Ref ref, VALUE? value) =>
        AsyncValue.data(other.watchValue(ref) == value ? IsNotEqual() : null);
