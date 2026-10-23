import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/single_form_value_state.dart';
import 'package:riverpod_forms/src/providers/form_value_notifier.dart';

final formValueProvider =
    NotifierProvider.family<
      SingleFormValueNotifier<dynamic, dynamic>,
      SingleFormValueState<dynamic, dynamic>,
      (String, SingleFormValue<dynamic, dynamic>)
    >((args) => SingleFormValueNotifier<dynamic, dynamic>(args.$1, args.$2));

final class SingleFormValueNotifier<VALUE, ERROR>
    extends
        FormValueNotifier<VALUE, ERROR, SingleFormValueState<VALUE, ERROR>> {
  final SingleFormValue<VALUE, ERROR> proxy;

  SingleFormValueNotifier(String key, this.proxy) : super(key, proxy.initial) {
    proxy.setValue = setValue;
  }

  AsyncValue<dynamic> _validateDynamic(Ref ref, dynamic value) =>
      proxy.validateDynamic(ref, value);

  @override
  SingleFormValueState<VALUE, ERROR> build() =>
      SingleFormValueState<VALUE, ERROR>(
        isDirty: isDirty,
        isInitializing: isInitializing,
        isEnabled: proxy.isEnabled?.call(ref) ?? true,
        isVisible: proxy.isVisible?.call(ref) ?? true,
        error: validateField
            ? ValidationState.fromAsyncValue<ERROR>(
                _validateDynamic(ref, value).as<ERROR?>(),
              )
            : null,
        value: value,
        values: proxy.values?.call(ref),
      );
}
