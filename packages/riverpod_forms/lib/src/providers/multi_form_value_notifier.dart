import 'package:async_value_tools/async_value_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/single_form_value_state.dart';
import 'package:riverpod_forms/src/providers/single_form_value_notifier.dart';

final multiFormValueProvider =
    NotifierProvider.family<
      MultiFormValueNotifier<dynamic, dynamic>,
      FormMultipleValueState<dynamic, dynamic>,
      MultiFormValueProviderArgs
    >((args) => MultiFormValueNotifier<dynamic, dynamic>(args.$1, args.$2));

final class MultiFormValueNotifier<VALUE, ERROR>
    extends
        FormValueNotifier<
          List<VALUE>?,
          ERROR,
          FormMultipleValueState<VALUE, ERROR>
        > {
  final String key;
  final MultiFormValue<VALUE, ERROR> proxy;
  late final AsyncDebouncer _debouncer;

  List<VALUE>? value;
  bool isDirty = false;

  MultiFormValueNotifier(this.key, this.proxy) : super(key, proxy.initial) {
    proxy.setValue = setValue;
    _debouncer = AsyncDebouncer(Duration(milliseconds: 80));
  }

  void setValue(List<VALUE>? value) {
    _debouncer.run(() async {
      this.value = value;
      isDirty = true;
      ref.invalidateSelf();
    });
  }

  AsyncValue<dynamic> _validateDynamic(Ref ref, dynamic value) =>
      proxy.validateDynamic(ref, value);

  void validate() {
    isDirty = true;
    ref.invalidateSelf();
  }

  @override
  FormMultipleValueState<VALUE, ERROR> build() =>
      FormMultipleValueState<VALUE, ERROR>(
        isDirty: isDirty,
        isInitializing: isInitializing,
        isEnabled: proxy.isEnabled?.call(ref) ?? true,
        isVisible: proxy.isVisible?.call(ref) ?? true,
        error: ValidationState.fromAsyncValue<ERROR>(
          _validateDynamic(ref, value).as<ERROR?>(),
        ),
        value: value,
        values: proxy.values.call(ref),
      );
}
