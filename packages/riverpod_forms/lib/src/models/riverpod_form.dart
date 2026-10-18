import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_forms/riverpod_forms.dart';
import 'package:riverpod_forms/src/models/riverpod_form_value_state.dart';
import 'package:riverpod_forms/src/providers/form_value_notifier.dart';
import 'package:uuid/uuid.dart';

part 'riverpod_form_value.dart';

typedef ValidFormSnapshot = Map<String, dynamic>;

abstract class RiverpodForm<RESULT>
    extends Iterable<FormValueProxy<dynamic, dynamic>> {
  @protected
  @visibleForOverriding
  RESULT getResult(ValidFormSnapshot snapshot);

  RiverpodForm();

  ValidFormSnapshot? _validSnapshot(WidgetRef ref) {
    var entries = this.map((value) {
      var s = value.readW(ref);
      if (s.isValid) {
        return MapEntry(value.key, s.value);
      } else {
        return null;
      }
    });
    if (entries.any((e) => e == null)) {
      return null;
    }
    return Map.fromEntries(entries.nonNulls);
  }

  void validate(WidgetRef ref) =>
      forEach((field) => field.validator);

  @nonVirtual
  RESULT? validateThenGetResult(WidgetRef ref) =>
      whenNotNull(_validSnapshot(ref), then: getResult);
}

final class RiverpodFormState<MODEL extends RiverpodForm>(
  final MODEL model,
  final bool isValid,
);
