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

  FormSingleValueState<T, E> as<T, E>() => FormSingleValueState<T, E>(
    isDirty: isDirty,
    error: error.as<E>(),
    value: value as T?,
    values: values as AsyncValue<List<T>>?,
  );

  Result<VALUE, ERROR> get result => isValid
      ? Valid<VALUE, ERROR>(value as VALUE)
      : Invalid<VALUE, ERROR>(error);
}

class FormMultipleValueState<VALUE, ERROR>({
  required final bool isDirty,
  final ValidationState<ERROR> error = const ValidationSuccess(),
  final List<VALUE>? value,
  required final AsyncValue<List<VALUE>> values,
}) {
  bool get isValid => error is ValidationSuccess<ERROR>;

  FormMultipleValueState<T, E> as<T, E>() => FormMultipleValueState<T, E>(
    isDirty: isDirty,
    error: error.as<E>(),
    value: value as List<T>?,
    values: values as AsyncValue<List<T>>,
  );
}
