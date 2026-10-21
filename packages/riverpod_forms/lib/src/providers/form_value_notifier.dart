import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';

final formValueProvider =
    NotifierProvider.family<
      FormValueNotifier<dynamic, dynamic>,
      FormSingleValueState<dynamic, dynamic>,
      SingleFormValueProviderArgs
    >((args) => FormValueNotifier<dynamic, dynamic>(args.$1, args.$2));

final class FormValueNotifier<VALUE, ERROR>
    extends Notifier<FormSingleValueState<VALUE, ERROR>> {
  final String key;
  final FormSingleValueProxy<VALUE, ERROR> valueProxy;
  late final AsyncDebouncer _debouncer;
  VALUE? value;
  bool isDirty = false;

  FormValueNotifier(this.key, this.valueProxy) : value = valueProxy.initial {
    valueProxy.setValue = setValue;
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
      valueProxy.validateDynamic(ref, value);

  void validate() {
    isDirty = true;
    ref.invalidateSelf();
  }

  @override
  FormSingleValueState<VALUE, ERROR> build() =>
      FormSingleValueState<VALUE, ERROR>(
        isDirty: isDirty,
        error: ValidationState.fromAsyncValue<ERROR>(
          _validateDynamic(ref, value).as<ERROR?>(),
        ),
        value: value,
        values: valueProxy.values?.call(ref),
      );
}
