import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

abstract class FormValue<
  VALUE,
  ERROR,
  STATE extends FormValueState<VALUE, ERROR>
> {
  FormValue({
    this.validator,
    Value<VALUE?> initial = const Value.sync(null),
    this.isEnabled,
    this.isVisible,
  }) {
    this.initial = initial.watch;
  }

  static FormValue<VALUE?, ERROR, FormSingleValueState<VALUE, ERROR>>
  single<VALUE, ERROR>({
    Validator<VALUE, ERROR>? validator,
    Value<VALUE?> initial = const Value.sync(null),
    AsyncValue<List<VALUE>> Function(Ref ref)? values,
  }) => SingleFormValue<VALUE, ERROR>(
    initial: initial,
    validator: validator,
    values: values,
  );

  final Validator<VALUE, ERROR>? validator;
  final bool Function(Ref ref)? isEnabled;
  final bool Function(Ref ref)? isVisible;

  /// Resolves the initial value; `null` means there is no initial value.
  late final AsyncValue<VALUE?> Function(Ref ref) initial;

  late Function(VALUE value) setValue;
  final String id = _uuid.v4();

  FormValueState<VALUE, ERROR> watch(Ref ref);

  void enableValidate(Ref ref);
  void enableValidateW(WidgetRef ref);
  void markDirtyW(WidgetRef ref);
  VALUE? watchValue(Ref ref);

  STATE watchW(WidgetRef ref);

  STATE read(Ref ref);

  STATE readW(WidgetRef ref);

  AsyncValue<ERROR?> watchValidationDynamic(Ref ref, dynamic val) =>
      validator?.watch(ref, val) ?? AsyncValue.data(null);

  VALUE getValid(ValidFormSnapshot snapshot) => snapshot[id] as VALUE;
}
