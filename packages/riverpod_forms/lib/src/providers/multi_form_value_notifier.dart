import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms/src/providers/form_value_notifier.dart';

final formMulipleValueProvider =
    NotifierProvider.family<
      MultiFormValueNotifier<dynamic, dynamic, dynamic>,
      FormMultipleValueState<dynamic, dynamic, dynamic>,
      MultiFormValueProviderArgs
    >(
      (args) =>
          MultiFormValueNotifier<dynamic, dynamic, dynamic>(args.$1, args.$2),
    );

final class MultiFormValueNotifier<VALUE, ERROR, ITEM_ERROR>
    extends
        FormValueNotifier<
          List<VALUE>,
          ERROR,
          FormMultipleValueState<VALUE, ERROR, ITEM_ERROR>
        > {
  final MultiFormValue<VALUE, ERROR, ITEM_ERROR> proxy;

  MultiFormValueNotifier(String key, this.proxy)
    : super(key, proxy.initial ?? [], []) {
    proxy.setValue = setValue;
    proxy.addValue = addValue;
    proxy.removeValue = removeValue;
    proxy.clear = clear;
  }

  AsyncValue<dynamic> _validateDynamic(Ref ref, dynamic value) =>
      proxy.validateDynamic(ref, value);

  List<AsyncValue<dynamic>> _validateItemsDynamic(
    Ref ref,
    List<dynamic> value,
  ) => proxy.validateItemsDynamic(ref, value);

  void addValue(VALUE v) {
    value = [...value, v];
    isDirty = true;
    validateField = true;
    ref.invalidateSelf();
  }

  void removeValue(VALUE v) {
    value = value.where((e) => e != v).toList();
    isDirty = true;
    validateField = true;
    ref.invalidateSelf();
  }

  void clear() {
    value = [];
    isDirty = true;
    validateField = true;
    ref.invalidateSelf();
  }

  @override
  FormMultipleValueState<VALUE, ERROR, ITEM_ERROR> build() => logIt(
    FormMultipleValueState<VALUE, ERROR, ITEM_ERROR>(
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
      itemErrors: validateField
          ? _validateItemsDynamic(ref, value)
                .map(
                  (r) =>
                      ValidationState.fromAsyncValue<
                        ItemError<VALUE, ITEM_ERROR>
                      >(r.as<ItemError<VALUE, ITEM_ERROR>?>()),
                )
                .toList()
          : const [],
      options: proxy.options.call(ref),
    ),
  );
}
