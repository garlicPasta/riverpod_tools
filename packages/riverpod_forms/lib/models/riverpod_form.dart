import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/models/validation_result.dart';
import 'package:riverpod_forms/utils/async_debouncer.dart';
import 'package:uuid/uuid.dart';

part 'riverpod_form_value.dart';

abstract class RiverpodForm extends Iterable<FormValueProxy<dynamic, dynamic>> {
  Map<String, dynamic>? snapshotWhenValid(Ref ref) {
    var state = map((v) {
      FormSingleValueState<dynamic, dynamic> value = v.read(ref);
      return (value.isValid, v.key, value.value);
    });
    if (state.every((e) => e.$1)) {
      return Map.fromEntries(state.map((e) => MapEntry(e.$2, e.$3)));
    }
    return null;
  }
}

final class FormState<MODEL extends RiverpodForm>(
  final MODEL model,
  final bool isValid,
);

class FormNotifier<MODEL extends RiverpodForm>
    extends Notifier<FormState<MODEL>> {
  MODEL model;
  final MODEL initialModel;

  static FormNotifier<M> make<M extends RiverpodForm>(M model) =>
      FormNotifier<M>(model);

  FormNotifier(this.model) : initialModel = model;

  void reset() {
    model = initialModel;
    ref.invalidateSelf();
  }

  @override
  FormState<MODEL> build() {
    final values = model.map((config) => config.watch(ref)).toList();

    return FormState<MODEL>(model, values.every((value) => value.isValid));
  }
}
