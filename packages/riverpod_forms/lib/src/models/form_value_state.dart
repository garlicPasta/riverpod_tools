import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/providers/multi_form_value_notifier.dart';

abstract class FormValueState<VALUE, ERROR>({
  final bool isDirty = false,
  final bool isEnabled = true,
  final bool isVisible = true,
  required final ValidationState<ERROR> error,
  final VALUE? value,
  final AsyncValue<VALUE?> initial = const AsyncValue.data(null),
}) extends Equatable {
  bool get isInitializing => initial.isLoading;
  bool? get isValid => (error is ValidationSuccess<ERROR>);

  @override
  List<Object?> get props => [
    isDirty,
    isEnabled,
    isVisible,
    value,
    error,
    initial,
  ];
}

class FormSingleValueState<VALUE, ERROR>({
  required super.isDirty,
  super.isEnabled,
  super.isVisible,
  super.value,
  super.initial,
  super.error = const ValidationSuccess(),
  final AsyncValue<List<VALUE>>? values,
  final AsyncValue<List<VALUE>>? suggestions,
}) extends FormValueState<VALUE, ERROR> {
  FormSingleValueState<T, E> as<T, E>() => FormSingleValueState<T, E>(
    isDirty: isDirty,
    isEnabled: isEnabled,
    isVisible: isVisible,
    error: error.as<E>(),
    value: value as T?,
    initial: initial.whenData((v) => v as T?),
    values: values?.whenData((v) => v.cast<T>()),
    suggestions: suggestions?.whenData((v) => v.cast<T>()),
  );

  @override
  String toString() =>
      'FormSingeValuesState($value) isDirty=$isDirty isEnabled=$isEnabled isVisible=$isVisible error=$error initial=$initial';
}

class FormMultipleValueState<VALUE, ERROR, ITEM_ERROR>({
  required super.isDirty,
  required super.error,
  super.isEnabled,
  super.isVisible,
  super.initial,
  final AsyncValue<List<VALUE>> options = const AsyncValue.data([]),
  final List<ValidationState<ItemError<VALUE, ITEM_ERROR>>> itemErrors =
      const [],
  final List<VALUE> value = const [],
  final ListDelta<VALUE>? delta,
}) extends FormValueState<List<VALUE>, ERROR> {
  FormMultipleValueState<VAL, ERR, ITEM_ERR> as<VAL, ERR, ITEM_ERR>() =>
      FormMultipleValueState<VAL, ERR, ITEM_ERR>(
        isDirty: isDirty,
        isEnabled: isEnabled,
        isVisible: isVisible,
        value: value.cast<VAL>(),
        initial: initial.whenData((v) => v?.cast<VAL>()),
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
      'FormMultipleValuesState($value) isDirty=$isDirty isEnabled=$isEnabled isVisible=$isVisible error=$error itemErrors=${itemErrors.isEmpty ? 'none' : itemErrors.join(',')} options=$options';
}
