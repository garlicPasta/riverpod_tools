import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';

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
          config.validateDynamic(ref, value) as AsyncValue<ERROR?>,
        ),
        value: value,
        values: values?.call(ref),
      ),
    FormMultipleValueProxy<dynamic, dynamic>() => throw UnimplementedError(),
  };
}
