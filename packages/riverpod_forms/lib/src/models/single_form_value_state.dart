import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';

abstract class FormValueState<VALUE, ERROR>({
  final bool isDirty = false,
  final bool isEnabled = true,
  final bool isVisible = true,
  required final bool isInitializing,
  final VALUE? value,
  final ValidationState<ERROR>? error,
}) extends Equatable {
  bool? get isValid => error == null ? null : error is ValidationSuccess<ERROR>;
  @override
  List<Object?> get props => [
    isDirty,
    isEnabled,
    isVisible,
    isInitializing,
    value,
    error,
  ];
}

class SingleFormValueState<VALUE, ERROR>({
  required super.isDirty,
  required super.isInitializing,
  super.isEnabled,
  super.isVisible,
  super.value,
  super.error = const ValidationSuccess(),
  final AsyncValue<List<VALUE>>? values,
  final AsyncValue<List<VALUE>>? suggestions,
}) extends FormValueState<VALUE, ERROR> {
  SingleFormValueState<T, E> as<T, E>() => SingleFormValueState<T, E>(
    isDirty: isDirty,
    isEnabled: isEnabled,
    isVisible: isVisible,
    error: error?.as<E>(),
    value: value as T?,
    values: values as AsyncValue<List<T>>?,
    suggestions: suggestions as AsyncValue<List<T>>?,
    isInitializing: isInitializing,
  );
}

class FormMultipleValueState<VALUE, ERROR>({
  required super.isDirty,
  required super.isInitializing,
  super.isEnabled,
  super.isVisible,
  required final AsyncValue<List<VALUE>> values,
  final ValidationState<ERROR> error = const ValidationSuccess(),
  final List<VALUE>? value,
}) extends FormValueState<List<VALUE>, ERROR> {
  FormMultipleValueState<T, E> as<T, E>() => FormMultipleValueState<T, E>(
    isDirty: isDirty,
    isEnabled: isEnabled,
    isVisible: isVisible,
    isInitializing: isInitializing,
    error: error.as<E>(),
    value: value as List<T>?,
    values: values as AsyncValue<List<T>>,
  );
}
