part of 'riverpod_form.dart';

class FormSingleValueState<VALUE, ERROR>({
  required final bool isDirty,
  final ValidationResult<ERROR> error = const ValidationSuccess(),
  final VALUE? value,
  final AsyncValue<List<VALUE>>? values,
}) {
  bool get isValid => error is ValidationSuccess<ERROR>;
}

class FormMultipleValueState<VALUE, ERROR>({
  required final bool isDirty,
  final AsyncValue<ERROR?> error = const AsyncData(null),
  final List<VALUE>? value,
  required AsyncValue<List<VALUE>> values,
}) {
  bool get isValid =>
      !error.isLoading && !error.hasError && error.value == null;
}

var _uuid = Uuid();

typedef FormValueValidator<VALUE, ERROR> = AsyncValue<ERROR?> Function(
  Ref ref,
  VALUE? value,
);

sealed class FormValueProxy<VALUE, ERROR>({
  required this.validator,
  this.initial,
}) {
  final FormValueValidator<VALUE, ERROR> validator;
  final VALUE? initial;

  late Function(VALUE? value) setValue;
  final String key = _uuid.v4();

  AsyncValue<dynamic> validateDynamic(Ref ref, dynamic value) =>
      validator(ref, value as VALUE?);

  FormSingleValueState<VALUE, ERROR> watch(Ref ref) {
    final FormSingleValueState<dynamic, dynamic> state = ref.watch(
      formValueProvider((key, this)),
    );
    return FormSingleValueState<VALUE, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as VALUE?,
      values: state.values as AsyncValue<List<VALUE>>?,
    );
  }

  FormSingleValueState<VALUE, ERROR> watchW(WidgetRef ref) {
    final FormSingleValueState<dynamic, dynamic> state = ref.watch(
      formValueProvider((key, this)),
    );
    return FormSingleValueState<VALUE, ERROR>(
      isDirty: state.isDirty,
      error: state.error.as<ERROR>(),
      value: state.value as VALUE?,
      values: state.values as AsyncValue<List<VALUE>>?,
    );
  }

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

  VALUE getFromSnapshot(Map<String, dynamic> snapshot) =>
      snapshot[key] as VALUE;
}

final class FormSingleValueProxy<VALUE, ERROR>
    extends FormValueProxy<VALUE, ERROR> {
  FormSingleValueProxy({required super.validator, super.initial, this.values});

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

@internal
final formValueProvider =
    NotifierProvider.family<
      _FormValue<dynamic, dynamic>,
      FormSingleValueState<dynamic, dynamic>,
      FormValueProviderArgs
    >((args) => _FormValue<dynamic, dynamic>(args.$1, args.$2));

class _FormValue<VALUE, ERROR>
    extends Notifier<FormSingleValueState<VALUE, ERROR>> {
  final String key;
  final FormValueProxy<VALUE, ERROR> config;
  late final AsyncDebouncer debouncer;
  VALUE? value;
  bool isDirty = false;

  _FormValue(this.key, this.config) : value = config.initial {
    config.setValue = setValue;
    debouncer = AsyncDebouncer(Duration(milliseconds: 80));
  }

  void setValue(VALUE? value) {
    debouncer.run(() async {
      this.value = value;
      isDirty = true;
      ref.invalidateSelf();
    });
  }

  @override
  FormSingleValueState<VALUE, ERROR> build() => switch (config) {
    FormSingleValueProxy<VALUE, ERROR>(:final values) =>
      FormSingleValueState<VALUE, ERROR>(
        isDirty: isDirty,
        error: ValidationResult.fromAsyncValue<ERROR>(
          config.validateDynamic(ref, value) as AsyncValue<ERROR?>,
        ),
        value: value,
        values: values?.call(ref),
      ),
    FormMultipleValueProxy<dynamic, dynamic>() => throw UnimplementedError(),
  };
}
