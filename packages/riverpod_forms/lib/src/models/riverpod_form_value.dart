part of 'riverpod_form.dart';

var _uuid = Uuid();

var asFutureProvider = FutureProvider.family(
  (
    Ref ref,
    ({dynamic value, Future<dynamic> Function(dynamic value) validator}) params,
  ) => params.validator(params.value),
);

sealed class FormValueProxy<VALUE, ERROR>({this.validator, this.initial}) {
  final Validator<VALUE, ERROR>? validator;
  final VALUE? initial;

  late Function(VALUE? value) setValue;
  final String key = _uuid.v4();

  AsyncValue<ERROR?> validateDynamic(Ref ref, dynamic val) =>
      validator?.normalize(ref, val) ?? AsyncData<ERROR?>(null);

  NotifierProvider<FormValue, FormSingleValueState<dynamic, dynamic>>
  get _provider => formValueProvider((key, this));

  FormSingleValueState<VALUE, ERROR> watch(Ref ref) =>
      ref.watch(_provider).as<VALUE, ERROR>();

  void validate(Ref ref) {
    ref.read(_provider.notifier).validate();
  }

  VALUE? watchValue(Ref ref) =>
      ref.watch(formValueProvider((key, this)).select((s) => s.value))
          as VALUE?;

  FormSingleValueState<VALUE, ERROR> watchW(WidgetRef ref) =>
      ref.watch(formValueProvider((key, this))).as<VALUE, ERROR>();

  FormSingleValueState<VALUE, ERROR> read(Ref ref) {
    final FormSingleValueState<dynamic, dynamic> state = ref.read(
      formValueProvider((key, this)),
    );
    return FormSingleValueState<VALUE, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as VALUE?,
      values: state.values as AsyncValue<List<VALUE>>?,
    );
  }

  FormSingleValueState<VALUE, ERROR> readW(WidgetRef ref) {
    final FormSingleValueState<dynamic, dynamic> state = ref.read(
      formValueProvider((key, this)),
    );
    return FormSingleValueState<VALUE, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as VALUE?,
      values: state.values as AsyncValue<List<VALUE>>?,
    );
  }

  VALUE getValid(ValidFormSnapshot snapshot) => snapshot[key] as VALUE;
}

final class FormSingleValueProxy<VALUE, ERROR>
    extends FormValueProxy<VALUE, ERROR> {
  FormSingleValueProxy({super.validator, super.initial, this.values});

  final AsyncValue<List<VALUE>> Function(Ref ref)? values;
}

final class FormMultipleValueProxy<VALUE, ERROR>
    extends FormValueProxy<List<VALUE>, ERROR> {
  FormMultipleValueProxy({
    required super.validator,
    super.initial,
    this.values,
  });

  final AsyncValue<List<VALUE>> Function(Ref ref)? values;
}

typedef FormValueProviderArgs = (String, FormValueProxy<dynamic, dynamic>);
