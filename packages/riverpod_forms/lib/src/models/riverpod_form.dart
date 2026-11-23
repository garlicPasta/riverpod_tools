import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/form_value_state.dart';
import 'package:riverpod_forms/src/providers/single_form_value_notifier.dart';

part 'form_single_value.dart';

typedef ValidFormSnapshot = Map<String, dynamic>;

abstract class RiverpodForm<RESULT> extends Iterable<FormValue> {
  @protected
  @visibleForOverriding
  RESULT getResult(ValidFormSnapshot snapshot);

  RiverpodForm();

  ValidFormSnapshot? _validSnapshot(WidgetRef ref) {
    var entries = this.map((FormValue value) {
      var s = value.readW(ref);
      if (s.isValid == true) {
        return MapEntry(value.id, s.value);
      } else {
        return null;
      }
    });

    if (entries.any((e) => e == null)) {
      return null;
    }
    return Map.fromEntries(entries.nonNulls);
  }

  void validateFields(WidgetRef ref) =>
      forEach((field) => field.enableValidateW(ref));

  void markDirty(WidgetRef ref) => forEach((field) => field.markDirtyW(ref));

  @nonVirtual
  RESULT? validateThenGetResult(WidgetRef ref) {
    validateFields(ref);
    markDirty(ref);
    return whenNull(_validSnapshot(ref), then: getResult);
  }
}

final class RiverpodFormState<MODEL extends RiverpodForm>(
  final MODEL model,
  final bool? isValid,
) extends Equatable {
  @override
  List<Object?> get props => [model, isValid];
}
