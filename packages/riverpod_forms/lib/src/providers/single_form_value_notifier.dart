import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms/src/providers/form_value_notifier.dart';

final formValueProvider =
    NotifierProvider.family<
      SingleFormValueNotifier<dynamic, dynamic>,
      FormSingleValueState<dynamic, dynamic>,
      (String, SingleFormValue<dynamic, dynamic>)
    >((args) => SingleFormValueNotifier<dynamic, dynamic>(args.$1, args.$2));

final class SingleFormValueNotifier<VALUE, ERROR>
    extends
        FormValueNotifier<VALUE?, ERROR, FormSingleValueState<VALUE, ERROR>> {
  final SingleFormValue<VALUE, ERROR> proxy;

  SingleFormValueNotifier(String key, this.proxy)
    : super(key: key, value: null) {
    proxy.setValue = setValue;
  }

  AsyncValue<dynamic> _validateDynamic(Ref ref, dynamic value) =>
      proxy.watchValidationDynamic(ref, value);

  @override
  FormSingleValueState<VALUE, ERROR> build() {
    var v = value ?? proxy.initial(ref).value;
    return logIt(
      FormSingleValueState<VALUE, ERROR>(
        initial: proxy.initial(ref),
        isDirty: isDirty,
        isEnabled: proxy.isEnabled?.call(ref) ?? true,
        isVisible: proxy.isVisible?.call(ref) ?? true,
        error: ValidationState.fromAsyncValue<ERROR>(
          _validateDynamic(ref, v).as<ERROR?>(),
        ),
        value: v,
        values: proxy.values?.call(ref),
      ),
    );
  }
}
