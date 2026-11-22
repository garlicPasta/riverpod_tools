import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms/src/providers/form_value_notifier.dart';

final multiFormValueProvider =
    NotifierProvider.family<
      MultiFormValueNotifier<dynamic, dynamic>,
      FormMultipleValuesState<dynamic, dynamic>,
      MultiFormValueProviderArgs
    >((args) => MultiFormValueNotifier<dynamic, dynamic>(args.$1, args.$2));

final class MultiFormValueNotifier<VALUE, ERROR>
    extends
        FormValueNotifier<
          List<VALUE>,
          ERROR,
          FormMultipleValuesState<VALUE, ERROR>
        > {
  final MultiFormValue<VALUE, ERROR> proxy;

  MultiFormValueNotifier(String key, this.proxy)
    : super(key, proxy.initial ?? [], []) {
    proxy.setValue = setValue;
    proxy.addValue = addValue;
    proxy.removeValue = removeValue;
    proxy.clear = clear;
  }

  AsyncValue<dynamic> _validateDynamic(Ref ref, dynamic value) =>
      proxy.validateDynamic(ref, value);

  void addValue(VALUE v) {
    value.add(v);
    isDirty = true;
    ref.invalidateSelf();
  }

  void removeValue(VALUE v) {
    value.remove(v);
    isDirty = true;
    ref.invalidateSelf();
  }

  void clear() {
    value.clear();
    isDirty = true;
    ref.invalidateSelf();
  }

  @override
  FormMultipleValuesState<VALUE, ERROR> build() =>
      FormMultipleValuesState<VALUE, ERROR>(
        isDirty: isDirty,
        isInitializing: isInitializing,
        isEnabled: proxy.isEnabled?.call(ref) ?? true,
        isVisible: proxy.isVisible?.call(ref) ?? true,
        error: validateField
            ? ValidationState.fromAsyncValue<ERROR>(
                _validateDynamic(ref, value).as<ERROR?>(),
              )
            : ValidationSuccess(),
        value: value,
        options: proxy.options.call(ref),
      );
}
