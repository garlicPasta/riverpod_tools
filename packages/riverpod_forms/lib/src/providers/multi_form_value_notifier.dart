import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms/src/providers/form_value_notifier.dart';

final formMulipleValueProvider =
    NotifierProvider.family<
      MultiFormValueNotifier,
      FormMultipleValueState,
      MultiFormValueProviderArgs
    >((args) => MultiFormValueNotifier(args.$1, args.$2));

class ListDelta<VALUE>(
  final List<VALUE> added,
  final List<VALUE> removed,
  final List<VALUE> unchanged,
) {
  ListDelta.fromInitial(List<VALUE> initial, List<VALUE> current)
    : this(
        current.where((e) => !initial.contains(e)).toList(),
        initial.where((e) => !current.contains(e)).toList(),
        current.where(initial.contains).toList(),
      );
}

final class MultiFormValueNotifier<VALUE, ERROR, ITEM_ERROR>
    extends
        FormValueNotifier<
          List<VALUE>,
          ERROR,
          FormMultipleValueState<VALUE, ERROR, ITEM_ERROR>
        > {
  final MultiFormValue<VALUE, ERROR, ITEM_ERROR> proxy;

  MultiFormValueNotifier(String key, this.proxy) : super(key: key, value: []) {
    proxy.setValue = setValue;
    proxy.addValue = addValue;
    proxy.removeValue = removeValue;
    proxy.clear = clear;
  }

  AsyncValue<dynamic> _validateDynamic(Ref ref, dynamic value) =>
      proxy.watchValidationDynamic(ref, value);

  List<AsyncValue<dynamic>> _validateItemsDynamic(
    Ref ref,
    List<dynamic> value,
  ) => proxy.validateItemsDynamic(ref, value);

  void _makeDirtyAndValidate() {
    isDirty = true;
  }

  void addValue(VALUE v) {
    value = [...value, v];
    _makeDirtyAndValidate();
    ref.invalidateSelf();
  }

  void removeValue(VALUE v) {
    value = value.where((e) => e != v).toList();
    _makeDirtyAndValidate();
    ref.invalidateSelf();
  }

  void clear() {
    value = [];
    _makeDirtyAndValidate();
    ref.invalidateSelf();
  }

  @override
  FormMultipleValueState<VALUE, ERROR, ITEM_ERROR> build() => logIt(
    FormMultipleValueState<VALUE, ERROR, ITEM_ERROR>(
      isDirty: isDirty,
      initial: initialValue.watch(ref),
      isEnabled: proxy.isEnabled?.call(ref) ?? true,
      isVisible: proxy.isVisible?.call(ref) ?? true,
      delta: initialValue
          .watch(ref)
          .whenData((v) => ListDelta.fromInitial(v ?? <VALUE>[], value))
          .value,
      error: ValidationState.fromAsyncValue<ERROR>(
        _validateDynamic(ref, value).as<ERROR?>(),
      ),
      value: value,
      itemErrors: _validateItemsDynamic(ref, value)
          .map(
            (r) => ValidationState.fromAsyncValue<ItemError<VALUE, ITEM_ERROR>>(
              r.as<ItemError<VALUE, ITEM_ERROR>?>(),
            ),
          )
          .toList(),
      options: proxy.options.call(ref),
    ),
  );
}
