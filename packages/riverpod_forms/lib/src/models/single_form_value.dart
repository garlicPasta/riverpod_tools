part of 'riverpod_form.dart';

final class SingleFormValue<VALUE, ERROR>
    extends SingleValueFormValue<VALUE, ERROR> {
  SingleFormValue({
    super.validator,
    super.initial,
    this.values,
    this.getSuggestion,
  });

  SingleFormValueState<VALUE, ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<VALUE, ERROR>();

  void validate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  AsyncValue<List<VALUE>> Function(Ref ref, Value value)? getSuggestion;

  NotifierProvider<
    SingleFormValueNotifier,
    SingleFormValueState<dynamic, dynamic>
  >
  get _provider => formValueProvider((key, this));

  VALUE? watchValue(Ref ref) =>
      ref.watch(formValueProvider((key, this)).select((s) => s.value))
          as VALUE?;

  SingleFormValueState<VALUE, ERROR> watchW(WidgetRef ref) =>
      ref.watch(formValueProvider((key, this))).as<VALUE, ERROR>();

  SingleFormValueState<VALUE, ERROR> read(Ref ref) =>
      ref.read(formValueProvider((key, this))).as<VALUE, ERROR>();

  SingleFormValueState<VALUE, ERROR> readW(WidgetRef ref) =>
      ref.read(formValueProvider((key, this))).as<VALUE, ERROR>();

  final AsyncValue<List<VALUE>> Function(Ref ref)? values;
}
