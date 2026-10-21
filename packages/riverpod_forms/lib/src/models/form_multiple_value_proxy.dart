import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';
import 'package:riverpod_forms/src/providers/multi_form_value_notifier.dart';

typedef MultiFormValueProviderArgs = (
  String,
  FormMultipleValueProxy<dynamic, dynamic>,
);

final class FormMultipleValueProxy<T, ERROR>
    extends FormValueProxy<List<T>, ERROR, FormMultipleValueState<T, ERROR>> {
  FormMultipleValueProxy({
    super.initial,
    required this.values,
    required super.validator,
  });

  FormMultipleValueState<T, ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<T, ERROR>();

  void validate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  NotifierProvider<
    MultiFormValueNotifier,
    FormMultipleValueState<dynamic, dynamic>
  >
  get _provider => multiFormValueProvider((key, this));

  List<T>? watchValue(Ref ref) =>
      ref.watch(multiFormValueProvider((key, this)).select((s) => s.value))
          as List<T>?;

  FormMultipleValueState<T, ERROR> watchW(WidgetRef ref) =>
      ref.watch(multiFormValueProvider((key, this))).as<T, ERROR>();

  FormMultipleValueState<T, ERROR> read(Ref ref) {
    final FormMultipleValueState<dynamic, dynamic> state = ref.read(
      multiFormValueProvider((key, this)),
    );

    return FormMultipleValueState<T, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as List<T>?,
      values: state.values as AsyncValue<List<T>>,
    );
  }

  FormMultipleValueState<T, ERROR> readW(WidgetRef ref) {
    final FormMultipleValueState<dynamic, dynamic> state = ref.read(
      multiFormValueProvider((key, this)),
    );

    return FormMultipleValueState<T, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as List<T>?,
      values: state.values as AsyncValue<List<T>>,
    );
  }

  final AsyncValue<List<T>> Function(Ref ref) values;
}
