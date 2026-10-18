import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

sealed class Result<T, ERROR> {}

final class Valid<T, ERROR>(T value) extends Result<T, ERROR> {}

final class Invalid<T, ERROR>(ValidationState<ERROR> state)
    extends Result<T, ERROR> {}

class FormSingleValueState<VALUE, ERROR>({
  required final bool isDirty,

  final ValidationState<ERROR> error = const ValidationSuccess(),
  final VALUE? value,
  final AsyncValue<List<VALUE>>? values,
}) {
  bool get isValid => error is ValidationSuccess<ERROR>;
  Result<VALUE, ERROR> get result => isValid
      ? Valid<VALUE, ERROR>(value as VALUE)
      : Invalid<VALUE, ERROR>(error);
}

class FormMultipleValueState<VALUE, ERROR>({
  required final bool isDirty,
  final AsyncValue<ERROR?> error = const AsyncData(null),
  final List<VALUE>? value,
  required AsyncValue<List<VALUE>> values,
}) {
  bool get isValid =>
      !error.isLoading && !error.hasError && error.value == null;
}
