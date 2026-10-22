import 'dart:async';

import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/extension/future_or_extension.dart';
import 'package:riverpod_forms/src/models/single_form_value_state.dart';

final formValueProvider =
    NotifierProvider.family<
      SingleFormValueNotifier<dynamic, dynamic>,
      SingleFormValueState<dynamic, dynamic>,
      (String, SingleFormValue<dynamic, dynamic>)
    >((args) => SingleFormValueNotifier<dynamic, dynamic>(args.$1, args.$2));

abstract class FormValueNotifier<VALUE, ERROR, STATE> extends Notifier<STATE> {
  final String key;
  VALUE? value;
  bool isDirty = false;

  late bool isInitializing;
  late bool initializationFailed;

  FormValueNotifier(this.key, FutureOr<VALUE?> initial) {
    initial.handle(
      beforeValue: () {
        isInitializing = true;
        initializationFailed = false;
      },
      onValue: (VALUE? v) {
        value = v;
        isInitializing = false;
      },
      onError: (e) {
        initializationFailed = true;
        isInitializing = false;
      },
    );
  }
}

final class SingleFormValueNotifier<VALUE, ERROR>
    extends
        FormValueNotifier<VALUE, ERROR, SingleFormValueState<VALUE, ERROR>> {
  late final AsyncDebouncer _debouncer;
  final SingleFormValue<VALUE, ERROR> valueProxy;

  SingleFormValueNotifier(String key, this.valueProxy)
    : super(key, valueProxy.initial) {
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
  SingleFormValueState<VALUE, ERROR> build() =>
      SingleFormValueState<VALUE, ERROR>(
        isInitializing: isInitializing,
        isDirty: isDirty,
        error: ValidationState.fromAsyncValue<ERROR>(
          _validateDynamic(ref, value).as<ERROR?>(),
        ),
        value: value,
        values: valueProxy.values?.call(ref),
        isEnabled: valueProxy.isEnabled?.call(ref) ?? true,
        isVisible: valueProxy.isVisible?.call(ref) ?? true,
      );
}
