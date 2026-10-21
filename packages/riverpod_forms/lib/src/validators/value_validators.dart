import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/riverpod_form.dart';
import 'package:riverpod_forms/src/models/validators.dart';

final class IsEqual();
final class IsNotEqual();

RiverpodValidator<VALUE, IsEqual> makeIsEqual<VALUE>(
  FormValueProxy<VALUE, Object?, dynamic> other,
) => RiverpodValidator(
  (Ref ref, VALUE? value) =>
      AsyncValue.data(other.watchValue(ref) != value ? IsEqual() : null),
);

RiverpodValidator<VALUE, IsNotEqual> makeIsNotEqual<VALUE>(
  FormValueProxy<VALUE, Object?, dynamic> other,
) => RiverpodValidator(
  (Ref ref, VALUE? value) =>
      AsyncValue.data(other.watchValue(ref) == value ? IsNotEqual() : null),
);
