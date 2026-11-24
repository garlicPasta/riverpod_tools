import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms/src/providers/multi_form_value_notifier.dart';

typedef MultiFormValueProviderArgs = (String, MultiFormValue);

final class MultiFormValue<T, ERROR, ITEM_ERROR>
    extends
        FormValue<
          List<T>,
          ERROR,
          FormMultipleValueState<T, ERROR, ITEM_ERROR>
        > {
  Validator<T, ItemError<T, ITEM_ERROR>>? itemValidator;

  MultiFormValue({
    super.initial,
    super.isEnabled,
    super.isVisible,
    super.validator,
    Value<List<T>>? options,
    this.itemValidator,
  }) {
    this.options = options?.watch ?? (ref) => AsyncValue.data([]);
  }

  @override
  AsyncValue<ERROR?> watchValidationDynamic(Ref ref, dynamic val) =>
      super.watchValidationDynamic(ref, val is List ? val.cast<T>() : val);

  List<AsyncValue<ItemError<T, ITEM_ERROR>?>> validateItemsDynamic(
    Ref ref,
    List<dynamic> val,
  ) {
    final validator = itemValidator;
    if (validator == null) {
      return [];
    }
    final normalizedValidator = validator.watch;
    return val.map((v) => normalizedValidator(ref, v)).toList();
  }

  late Function(T value) addValue;
  late Function(T value) removeValue;
  late Function() clear;

  FormMultipleValueState<T, ERROR, ITEM_ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<T, ERROR, ITEM_ERROR>();

  void enableValidate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  NotifierProvider<
    MultiFormValueNotifier<dynamic, dynamic, dynamic>,
    FormMultipleValueState<dynamic, dynamic, dynamic>
  >
  get _provider => formMulipleValueProvider((id, this));

  List<T>? watchValue(Ref ref) =>
      ref.watch(formMulipleValueProvider((id, this)).select((s) => s.value))
          as List<T>?;

  FormMultipleValueState<T, ERROR, ITEM_ERROR> watchW(WidgetRef ref) => ref
      .watch(formMulipleValueProvider((id, this)))
      .as<T, ERROR, ITEM_ERROR>();

  FormMultipleValueState<T, ERROR, ITEM_ERROR> read(Ref ref) =>
      ref.read(formMulipleValueProvider((id, this))).as<T, ERROR, ITEM_ERROR>();

  FormMultipleValueState<T, ERROR, ITEM_ERROR> readW(WidgetRef ref) =>
      ref.read(formMulipleValueProvider((id, this))).as<T, ERROR, ITEM_ERROR>();

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
