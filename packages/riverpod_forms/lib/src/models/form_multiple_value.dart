import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms/src/models/value.dart';
import 'package:riverpod_forms/src/providers/as_future_provider.dart';
import 'package:riverpod_forms/src/providers/multi_form_value_notifier.dart';

typedef MultiFormValueProviderArgs = (String, MultiFormValue<dynamic, dynamic>);

final class MultiFormValue<T, ERROR>
    extends FormValue<List<T>, ERROR, FormMultipleValuesState<T, ERROR>> {
  MultiFormValue({
    super.initial,
    super.isEnabled,
    super.isVisible,
    super.validator,
    Value<List<T>>? options,
  }) {
    this.options = switch (options) {
      SyncValue<List<T>>(:final value) => (ref) => AsyncValue.data(value),
      FutureValue<List<T>>(:final value) => (ref) => ref.watch(
        futureToAsyncDataProvider(EqualFuture(id, value)),
      ) as AsyncValue<List<T>>,
      RiverpodValue<List<T>>(:final value) => value,
      null => (ref) => AsyncValue.data([]),
    };
  }

  @override
  AsyncValue<ERROR?> validateDynamic(Ref ref, dynamic val) =>
      super.validateDynamic(ref, val is List ? val.cast<T>() : val);

  late Function(T value) addValue;
  late Function(T value) removeValue;
  late Function() clear;

  FormMultipleValuesState<T, ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<T, ERROR>();

  void enableValidate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  NotifierProvider<
    MultiFormValueNotifier,
    FormMultipleValuesState<dynamic, dynamic>
  >
  get _provider => multiFormValueProvider((id, this));

  List<T>? watchValue(Ref ref) =>
      ref.watch(multiFormValueProvider((id, this)).select((s) => s.value))
          as List<T>?;

  FormMultipleValuesState<T, ERROR> watchW(WidgetRef ref) =>
      ref.watch(multiFormValueProvider((id, this))).as<T, ERROR>();

  FormMultipleValuesState<T, ERROR> read(Ref ref) =>
      ref.read(multiFormValueProvider((id, this))).as<T, ERROR>();

  FormMultipleValuesState<T, ERROR> readW(WidgetRef ref) =>
      ref.read(multiFormValueProvider((id, this))).as<T, ERROR>();

  late final AsyncValue<List<T>> Function(Ref ref) options;

  @override
  void enableValidateW(WidgetRef ref) {
    ref.read(_provider.notifier).validate();
  }

  @override
  void markDirtyW(WidgetRef ref) {
    ref.read(_provider.notifier).markDirty();
  }
}
