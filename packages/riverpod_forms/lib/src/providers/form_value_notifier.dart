import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';

final formValueProvider =
    NotifierProvider.family<
      FormValue<dynamic, dynamic>,
      FormSingleValueState<dynamic, dynamic>,
      FormValueProviderArgs
    >((args) => FormValue<dynamic, dynamic>(args.$1, args.$2));

final class FormValue<VALUE, ERROR>
    extends Notifier<FormSingleValueState<VALUE, ERROR>> {
  final String key;
  final FormValueProxy<VALUE, ERROR> config;
  late final AsyncDebouncer _debouncer;
  VALUE? value;
  bool isDirty = false;

  FormValue(this.key, this.config) : value = config.initial {
    config.setValue = setValue;
    _debouncer = AsyncDebouncer(Duration(milliseconds: 80));
  }

  void setValue(VALUE? value) {
    _debouncer.run(() async {
      this.value = value;
      isDirty = true;
      ref.invalidateSelf();
    });
  }

    AsyncValue<dynamic> _validateDynamic(Ref ref, dynamic value) =>
      config.validateDynamic(ref, value);

  void validate() {
    isDirty = true;
    ref.invalidateSelf();
  }

  @override
  FormSingleValueState<VALUE, ERROR> build() => switch (config) {
    FormSingleValueProxy<VALUE, ERROR>(:final values) =>
      FormSingleValueState<VALUE, ERROR>(
        isDirty: isDirty,
        error: ValidationState.fromAsyncValue<ERROR>(
          _validateDynamic(ref, value) as AsyncValue<ERROR?>,
        ),
        value: value,
        values: values?.call(ref),
      ),
    FormMultipleValueProxy<dynamic, dynamic>() => throw UnimplementedError(),
  };
}
