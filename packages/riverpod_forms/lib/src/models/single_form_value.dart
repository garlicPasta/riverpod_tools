part of 'riverpod_form.dart';

final class SingleFormValue<VALUE, ERROR>
    extends FormValue<VALUE, ERROR, SingleFormValueState<VALUE, ERROR>> {
  SingleFormValue({
    super.validator,
    super.initial,
    super.isEnabled,
    super.isVisible,
    this.values,
    this.getSuggestion,
  });

  SingleFormValueState<VALUE, ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<VALUE, ERROR>();

  void validate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  AsyncValue<List<VALUE>> Function(Ref ref, VALUE value)? getSuggestion;

  (String, SingleFormValue<dynamic, dynamic>) get _params => (key, this);

  NotifierProvider<
    SingleFormValueNotifier,
    SingleFormValueState<dynamic, dynamic>
  >
  get _provider => formValueProvider(_params);

  VALUE? watchValue(Ref ref) =>
      ref.watch(formValueProvider(_params).select((s) => s.value)) as VALUE?;

  SingleFormValueState<VALUE, ERROR> watchW(WidgetRef ref) =>
      ref.watch(formValueProvider(_params)).as<VALUE, ERROR>();

  SingleFormValueState<VALUE, ERROR> read(Ref ref) =>
      ref.read(formValueProvider(_params)).as<VALUE, ERROR>();

  SingleFormValueState<VALUE, ERROR> readW(WidgetRef ref) =>
      ref.read(formValueProvider(_params)).as<VALUE, ERROR>();

  final AsyncValue<List<VALUE>> Function(Ref ref)? values;

  @override
  void validateW(WidgetRef ref) {
    ref.read(_provider.notifier).validate();
  }
}
