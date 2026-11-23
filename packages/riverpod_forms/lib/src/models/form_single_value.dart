part of 'riverpod_form.dart';

final class SingleFormValue<VALUE, ERROR>
    extends FormValue<VALUE?, ERROR, FormSingleValueState<VALUE, ERROR>> {
  SingleFormValue({
    super.validator,
    super.initial,
    super.isEnabled,
    super.isVisible,
    this.values,
    this.getSuggestion,
  });

  FormSingleValueState<VALUE, ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<VALUE, ERROR>();

  @override
  void enableValidate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  AsyncValue<List<VALUE>> Function(Ref ref, VALUE value)? getSuggestion;

  (String, SingleFormValue<dynamic, dynamic>) get _params => (id, this);

  NotifierProvider<
    SingleFormValueNotifier,
    FormSingleValueState<dynamic, dynamic>
  >
  get _provider => formValueProvider(_params);

  VALUE? watchValue(Ref ref) =>
      ref.watch(formValueProvider(_params).select((s) => s.value)) as VALUE?;

  FormSingleValueState<VALUE, ERROR> watchW(WidgetRef ref) =>
      ref.watch(formValueProvider(_params)).as<VALUE, ERROR>();

  FormSingleValueState<VALUE, ERROR> read(Ref ref) =>
      ref.read(formValueProvider(_params)).as<VALUE, ERROR>();

  FormSingleValueState<VALUE, ERROR> readW(WidgetRef ref) =>
      ref.read(formValueProvider(_params)).as<VALUE, ERROR>();

  final AsyncValue<List<VALUE>> Function(Ref ref)? values;

  @override
  VALUE getValid(ValidFormSnapshot snapshot) => snapshot[id] as VALUE;

  @override
  void enableValidateW(WidgetRef ref) {
    ref.read(_provider.notifier).validate();
  }

  @override
  void markDirtyW(WidgetRef ref) {
    ref.read(_provider.notifier).markDirty();
  }
}
