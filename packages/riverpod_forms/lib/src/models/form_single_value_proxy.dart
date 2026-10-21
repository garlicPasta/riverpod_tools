part of 'riverpod_form.dart';

var _uuid = Uuid();

var asFutureProvider = FutureProvider.family(
  (
    Ref ref,
    ({dynamic value, Future<dynamic> Function(dynamic value) validator}) params,
  ) => params.validator(params.value),
);

abstract class FormValueProxy<VALUE, ERROR, STATE extends Object>({
  this.validator,
  this.initial,
}) {
  final Validator<VALUE, ERROR>? validator;
  final VALUE? initial;

  late Function(VALUE? value) setValue;
  final String key = _uuid.v4();

  STATE watch(Ref ref);

  void validate(Ref ref);

  VALUE? watchValue(Ref ref);

  STATE watchW(WidgetRef ref);

  STATE read(Ref ref);

  STATE readW(WidgetRef ref);

  AsyncValue<ERROR?> validateDynamic(Ref ref, dynamic val) =>
      validator?.normalize(ref, val) ?? AsyncValue.data(null);

  VALUE getValid(ValidFormSnapshot snapshot) => snapshot[key] as VALUE;
}

typedef SingleFormValueProviderArgs = (
  String,
  FormSingleValueProxy<dynamic, dynamic>,
);

final class FormSingleValueProxy<VALUE, ERROR>
    extends FormValueProxy<VALUE, ERROR, FormMultiValueState<VALUE, ERROR>> {
  FormSingleValueProxy({super.validator, super.initial, this.values});

  FormMultiValueState<VALUE, ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<VALUE, ERROR>();

  void validate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  NotifierProvider<FormValueNotifier, FormMultiValueState<dynamic, dynamic>>
  get _provider => formValueProvider((key, this));

  VALUE? watchValue(Ref ref) =>
      ref.watch(formValueProvider((key, this)).select((s) => s.value))
          as VALUE?;

  FormMultiValueState<VALUE, ERROR> watchW(WidgetRef ref) =>
      ref.watch(formValueProvider((key, this))).as<VALUE, ERROR>();

  FormMultiValueState<VALUE, ERROR> read(Ref ref) {
    final FormMultiValueState<dynamic, dynamic> state = ref.read(
      formValueProvider((key, this)),
    );
    return FormMultiValueState<VALUE, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as VALUE?,
      values: state.values as AsyncValue<List<VALUE>>?,
    );
  }

  FormMultiValueState<VALUE, ERROR> readW(WidgetRef ref) {
    final FormMultiValueState<dynamic, dynamic> state = ref.read(
      formValueProvider((key, this)),
    );
    return FormMultiValueState<VALUE, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as VALUE?,
      values: state.values as AsyncValue<List<VALUE>>?,
    );
  }

  final AsyncValue<List<VALUE>> Function(Ref ref)? values;
}
