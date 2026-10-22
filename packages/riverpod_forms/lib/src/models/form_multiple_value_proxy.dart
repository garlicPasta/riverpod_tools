import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/src/models/form_value.dart';
import 'package:riverpod_forms/src/models/single_form_value_state.dart';
import 'package:riverpod_forms/src/providers/multi_form_value_notifier.dart';

typedef MultiFormValueProviderArgs = (String, MultiFormValue<dynamic, dynamic>);

final class MultiFormValue<T, ERROR>
    extends FormValue<List<T>, ERROR, FormMultipleValueState<T, ERROR>> {

  MultiFormValue({
    super.initial,
    super.isEnabled,
    super.isVisible,
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

  FormMultipleValueState<T, ERROR> read(Ref ref) =>
      ref.read(multiFormValueProvider((key, this))).as<T, ERROR>();

  FormMultipleValueState<T, ERROR> readW(WidgetRef ref) =>
      ref.read(multiFormValueProvider((key, this))).as<T, ERROR>();

  final AsyncValue<List<T>> Function(Ref ref) values;
}
