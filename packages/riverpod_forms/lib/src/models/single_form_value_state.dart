import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

abstract class FormValueState<VALUE, ERROR>({
  final bool isDirty = false,
  final bool isEnabled = true,
  final bool isVisible = true,
  required final bool isInitializing,
  final VALUE? value,
  final ValidationState<ERROR> error = const ValidationSuccess(),
}) extends Equatable {
  @override
  List<Object?> get props => [isDirty, isInitializing, value, error];
}

class SingleFormValueState<VALUE, ERROR>({
  required super.isDirty,
  required super.isInitializing,
  super.value,
  super.error = const ValidationSuccess(),
  final AsyncValue<List<VALUE>>? values,
  final AsyncValue<List<VALUE>>? suggestions,
}) extends FormValueState<VALUE, ERROR> {
  bool get isValid => error is ValidationSuccess<ERROR>;

  SingleFormValueState<T, E> as<T, E>() => SingleFormValueState<T, E>(
    isDirty: isDirty,
    error: error.as<E>(),
    value: value as T?,
    values: values as AsyncValue<List<T>>?,
    isInitializing: isInitializing,
  );
}

class FormMultipleValueState<VALUE, ERROR>({
  required super.isDirty,
  required super.isInitializing,
  required final AsyncValue<List<VALUE>> values,
  final ValidationState<ERROR> error = const ValidationSuccess(),
  final List<VALUE>? value,
}) extends FormValueState<List<VALUE>, ERROR> {
  bool get isValid => error is ValidationSuccess<ERROR>;

  FormMultipleValueState<T, E> as<T, E>() => FormMultipleValueState<T, E>(
    isDirty: isDirty,
    isInitializing: isInitializing,
    error: error.as<E>(),
    value: value as List<T>?,
    values: values as AsyncValue<List<T>>,
  );
}
