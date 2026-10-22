import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/single_form_value_state.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

abstract class FormValue<VALUE, ERROR, STATE extends Object>({
  this.validator,
  this.initial,
  this.isEnabled,
  this.isVisible,
}) {
  static FormValue<VALUE, ERROR, SingleFormValueState<VALUE, ERROR>>
  single<VALUE, ERROR>({
    Validator<VALUE, ERROR>? validator,
    VALUE? initial,
    AsyncValue<List<VALUE>> Function(Ref ref)? values,
  }) => SingleFormValue<VALUE, ERROR>(
    initial: initial,
    validator: validator,
    values: values,
  );

  final Validator<VALUE, ERROR>? validator;
  final bool Function(Ref ref)? isEnabled;
  final bool Function(Ref ref)? isVisible;
  final FutureOr<VALUE?> initial;

  late Function(VALUE? value) setValue;
  final String key = _uuid.v4();

  STATE watch(Ref ref);

  void validate(Ref ref);

  VALUE? watchValue(Ref ref);

  STATE watchW(WidgetRef ref);

  STATE read(Ref ref);

  STATE readW(WidgetRef ref);

  AsyncValue<ERROR?> validateDynamic(Ref ref, dynamic val) =>
      validator?.normalize(ref, val) ?? AsyncValue.data(null);

  VALUE getValid(ValidFormSnapshot snapshot) => snapshot[key] as VALUE;
}
