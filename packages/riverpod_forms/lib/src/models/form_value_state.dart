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

class FormSingleValueState<VALUE, ERROR>({
  required super.isDirty,
  required super.isInitializing,
  super.isEnabled,
  super.isVisible,
  super.value,
  super.error = const ValidationSuccess(),
  final AsyncValue<List<VALUE>>? values,
  final AsyncValue<List<VALUE>>? suggestions,
}) extends FormValueState<VALUE, ERROR> {
  FormSingleValueState<T, E> as<T, E>() => FormSingleValueState<T, E>(
    isDirty: isDirty,
    isEnabled: isEnabled,
    isVisible: isVisible,
    error: error?.as<E>(),
    value: value as T?,
    values: values?.whenData((v) => v.cast<T>()),
    suggestions: suggestions?.whenData((v) => v.cast<T>()),
    isInitializing: isInitializing,
  );

  @override
  String toString() =>
      'FormSingeValuesState($value) isDirty=$isDirty isEnabled=$isEnabled isVisible=$isVisible isInit=$isInitializing error=$error';
}

class FormMultipleValueState<VALUE, ERROR, ITEM_ERROR>({
  required super.isDirty,
  required super.isInitializing,
  super.isEnabled,
  super.isVisible,
  final AsyncValue<List<VALUE>> options = const AsyncValue.data([]),
  final ValidationState<ERROR> error = const ValidationSuccess(),
  final List<ValidationState<ItemError<VALUE, ITEM_ERROR>>> itemErrors =
      const [],
  final List<VALUE> value = const [],
}) extends FormValueState<List<VALUE>, ERROR> {
  FormMultipleValueState<VAL, ERR, ITEM_ERR> as<VAL, ERR, ITEM_ERR>() =>
      FormMultipleValueState<VAL, ERR, ITEM_ERR>(
        isDirty: isDirty,
        isEnabled: isEnabled,
        isVisible: isVisible,
        isInitializing: isInitializing,
        value: value.cast<VAL>(),
        error: error.as<ERR>(),
        itemErrors: itemErrors
            .map((e) => e.as<ItemError<VAL, ITEM_ERR>>())
            .toList(),
        options: options.whenData((v) => v.cast<VAL>()),
      );

  @override
  List<Object?> get props => [...super.props, itemErrors, options];

  @override
  String toString() =>
      'FormMultipleValuesState($value) isDirty=$isDirty isEnabled=$isEnabled isVisible=$isVisible isInit=$isInitializing error=$error itemErrors=${itemErrors.isEmpty ? 'none' : itemErrors.join(',')} options=$options';
}
